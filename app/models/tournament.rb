class Tournament < ApplicationRecord
  require 'csv'
  has_many :participants
  belongs_to :format
  belongs_to :version, optional: true
  belongs_to :tournament_type
  attr_accessor :participant_number, :tabletop_url

  def create_squads
    if tabletop_url

      participants_from_tabletop(tabletop_url)
    end

    create_empty_squads

  end

  def create_empty_squads
    return if participant_number.to_i.zero?

    participant_number.to_i.times do |i|
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
    JSON(response.parsed_response)
  end

  def create_participant_from_tabletop(player_hash)
    Participant.create(
      Tournament_id: id,
      name: player_hash['name'],
      mov: player_hash['mov'],
      score: player_hash['score']&.to_i,
      sos: player_hash['sos']&.to_f,
      swiss_rank: player_hash.dig('rank', 'swiss')&.to_i,
      top_cut_rank: player_hash.dig('rank', 'elimination')&.to_i
    )
  end

  def participants_from_tabletop(url)

    tabletop_hash = get_json_from_tabletop(url)

    players_array = tabletop_hash.dig('tournament', 'players')
    return if players_array.nil? || players_array.empty?

    players_array.each do |player_hash|
      create_participant_from_tabletop(player_hash)
    end
  end
end
