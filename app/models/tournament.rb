class Tournament < ApplicationRecord
  require 'csv'
  has_many :participants
  belongs_to :format
  belongs_to :version, optional: true
  belongs_to :tournament_type
  attr_accessor :participant_number, :tabletop_url, :cryodex_json

  def create_squads
    success = false
    if tabletop_url.present?
      match = tabletop_url.match(/(tabletop.to\/[^\/]*)/)
      if match
        # Provide the protocol and add /listjuggler to the end
        full_url = 'https://' + match[1] + '/listjuggler'
        success =  participants_from_tabletop(full_url)
      end
    elsif cryodex_json.present?
      success = participants_from_cryodex(cryodex_json)
    end
    # If TTT or Crodex import can't find any players, create blank ones
    create_empty_squads(participant_number.to_i) unless success
  end

  def create_empty_squads(number)
    return if number.zero?

    number.times do |i|
      Participant.new(swiss_rank: i + 1, tournament_id: id).save
    end
  end

  def self.to_csv
    header = %w{tournamentName type format date playerName squad score mov sos swiss_rank top_cut_rank}
    CSV.generate(headers: true) do |csv|
      csv << header

      all.each do |tournament|
        tournament_name = tournament.name
        type = TournamentType.find(tournament.tournament_type_id).name
        format = Format.find(tournament.format_id).name
        date = tournament.date

        tournament.participants.order(:id).each do |participant|
          player_name = participant.name
          squad = participant.list_json
          score = participant.score
          mov = participant.mov
          sos = participant.sos
          swiss_rank = participant.swiss_rank
          top_cut_rank = participant.top_cut_rank

          output = [tournament_name, type, format, date, player_name, squad, score, mov, sos, swiss_rank, top_cut_rank]
          csv << output
        end
      end
    end
  end

  def get_json_from_tabletop(url)
    response = HTTParty.get(url)
    return {} if response.code == 404

    JSON(response.parsed_response)
  end

  def create_participant_from_json(player_hash)
    player = Participant.new(
      tournament_id: id,
      name: player_hash['name'],
      mov: player_hash['mov']&.to_i,
      score: player_hash['score']&.to_i,
      sos: player_hash['sos']&.to_f,
      swiss_rank: player_hash.dig('rank', 'swiss')&.to_i,
      top_cut_rank: player_hash.dig('rank', 'elimination')&.to_i
    )

    if player_hash['list'].present?
      player.list_json = JSON(player_hash['list'])
    end

    player.save
  end

  def participants_from_tabletop(url)
    tabletop_hash = get_json_from_tabletop(url)

    players_array = tabletop_hash.dig('tournament', 'players')
    return false if players_array.blank?

    players_array.each do |player_hash|
      create_participant_from_json(player_hash)
    end
  end

  def participants_from_cryodex(raw_json)
    parsed_json = JSON(raw_json)
    players_array = nil

    if parsed_json['players']
      players_array = parsed_json['players']
    elsif parsed_json.dig('tournament', 'players')
      players_array = parsed_json.dig('tournament', 'players')
    end

    return false if players_array.blank?

    players_array.each do |player_hash|
      create_participant_from_json(player_hash)
    end
  end
end
