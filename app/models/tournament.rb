class Tournament < ApplicationRecord
  require 'csv'
  has_many :participants
  has_many :rounds
  belongs_to :format
  belongs_to :version, optional: true
  belongs_to :tournament_type
  attr_accessor :participant_number, :tabletop_url, :cryodex_json, :round_number
  scope :updated_after, -> (update_date) { where!('updated_at > ?', update_date) if update_date.present? }

  def create_squads
    success = false
    if tabletop_url.present?
      # Check for tabletop.to
      match = tabletop_url.match(/(tabletop.to\/[^\/]*)/)
      if match
        # Provide the protocol and add /listjuggler to the end
        full_url = 'https://' + match[1] + '/listjuggler'
        success =  participants_from_tabletop(full_url)
      end
      # Check for Best Coast Pairings
      match = tabletop_url.match(/bestcoastpairings.com\/r\/([a-zA-Z\d]{8})/)
      if match
        full_url = "https://www.bestcoastpairings.com/r/" + match[1] + "?embed=true"
        success = scrape_participants_from_best_coast_pairings(full_url)
      end
    elsif cryodex_json.present?
      success = participants_from_cryodex(cryodex_json)
    end
    # If url or json import can't find any players, create blank ones
    create_empty_squads(participant_number.to_i) unless success
    puts round_number
    # If TTT or Crodex import weren't successful create empty rounds
    create_empty_rounds(round_number.to_i) unless success
  end

  def create_empty_rounds(number)
    return if number.zero?
    x = 1
    number.times do |i|
      Round.create(tournament_id:id, round_number:x)
      x=x+1
    end
  end

  def create_empty_squads(number)
    return if number.zero?

    number.times do |i|
      Participant.create(swiss_rank: i + 1, tournament_id: id)
    end
  end

  def serializable_hash(options={})
    super({}.merge(options || {}))
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

  def create_round_from_json(round_hash)
    round = Round.create(
      tournament_id: id,
      roundtype_id: Roundtype.find_by(name:round_hash['round-type']).id,
      round_number: round_hash['round-number']
    )

    matches_array = round_hash.dig('matches')
    puts matches_array
    matches_array.each do |match_hash|
      puts match_hash
      create_match_from_json(round.id, match_hash)
    end
  end

  def create_match_from_json(round_id, match_hash)
    player1 = Participant.find_by(tournament_id:id,name:match_hash['player1'])
    player2 = Participant.find_by(tournament_id:id,name:match_hash['player2'])
    winner = Participant.find_by(tournament_id:id,name:match_hash['winner'])
    player1points = match_hash['player1points']
    player2points = match_hash['player2points']
    if !winner.present? && player1points.present? && player2points.present?
      if player1points>player2points
        winner = player1
      elsif player2points>player1points
        winner = player2
      end
    end

    match = Match.create(
      round_id: round_id,
      player1_id: player1.present? ? player1.id : nil,
      player1_points: match_hash['player1points'],
      player2_id: player2.present? ? player2.id : nil,
      player2_points: match_hash['player2points'],
      result: match_hash['result'],
      winner_id: winner.present? ? winner.id : nil
    )
  end

  def participants_from_tabletop(url)
    tabletop_hash = get_json_from_tabletop(url)

    players_array = tabletop_hash.dig('tournament', 'players')
    return false if players_array.blank?

    players_array.each do |player_hash|
      create_participant_from_json(player_hash)
    end

    rounds_array = tabletop_hash.dig('tournament', 'rounds')

    if rounds_array.present?
      rounds_array.each do |round_hash|
        create_round_from_json(round_hash)
      end
    end
  end

  def participants_from_cryodex(raw_json)
    parsed_json = JSON(raw_json)
    players_array = nil
    rounds_array = nil

    if parsed_json['players']
      players_array = parsed_json['players']
    elsif parsed_json.dig('tournament', 'players')
      players_array = parsed_json.dig('tournament', 'players')
    end

    return false if players_array.blank?

    players_array.each do |player_hash|
      create_participant_from_json(player_hash)
    end

    if parsed_json['rounds']
      rounds_array = parsed_json['rounds']
    elsif parsed_json.dig('tournament', 'rounds')
      rounds_array = parsed_json.dig('tournament', 'rounds')
    end

    if rounds_array.present?
      rounds_array.each do |round_hash|
        create_round_from_json(round_hash)
      end
    end
  end

  def scrape_participants_from_best_coast_pairings(url)
    response = HTTParty.get(url)
    return false unless response.code == 200

    doc = Nokogiri::HTML(response.parsed_response)
    
    l = doc.css('div.row > div.tight > p > a').map { |link| link['href'] }

    doc.css('div.event-list > li').each do |participant_doc|
      Participant.create(
        tournament_id: id,
        name: participant_doc.css('.title > span')&.text,
        score: participant_doc.css('.scoresLabel li')[0]&.text&.to_i,
        mov: participant_doc.css('.scoresLabel li')[2]&.text&.to_i,
        swiss_rank: participant_doc.css('.placing')&.text&.to_i
      )
    end

    if l.present?
      match = url.match(/bestcoastpairings.com\/r\/([a-zA-Z\d]*)/)
      rounds = l[0].match(/\/event\/[a-zA-Z\d]*\?.*round=([\d]*)/)
      
      if rounds.present?
        rounds_counter = rounds[1].to_i
        rounds_counter.times do |i|
          round_url = "https://www.bestcoastpairings.com/event/" + match[1] + "?round=" + (i+1).to_s + "&embed=true"
          scrape_rounds_from_best_coast_pairings(round_url,(i+1))
        end
      end
    end
    true
  end

  def scrape_rounds_from_best_coast_pairings(url,round_number)
    response = HTTParty.get(url)
    return false unless response.code == 200

    doc = Nokogiri::HTML(response.parsed_response)
    
    round = Round.find_or_create_by(tournament_id:id,round_number:round_number,roundtype_id:1)
    
    doc.css('table.newTable > tr').drop(1).each do |match_doc|
      cells = match_doc.css('td')
      player1 = cells[0].css('span')[0]&.text
      player1_points = cells[0].css('span')[2]&.text&.to_i
      player2 = cells[2].css('span')[0]&.text
      player2_points = cells[2].css('span')[2]&.text&.to_i
      
      match = Match.create(round_id:round.id)
      player1_obj = Participant.find_by(name:player1)
      if player1_obj.present?
        match.player1_id = player1_obj.id
      end

      match.player1_points = player1_points
      player2_obj = Participant.find_by(name:player2)
      if player2_obj.present?
        match.player2_id = player2_obj.id
      end
      match.player2_points = player2_points
      if player1_points.to_i>player2_points.to_i
        match.result = "win"
        match.winner_id = match.player1_id
      elsif player1_points.to_i<player2_points.to_i
        match.result = "win"
        match.winner_id = match.player2_id
      elsif player1_points.to_i==player2_points.to_i
        if player2_points.nil?
          match.result = "bye"
          match.winner_id = match.player1_id
        else
          match.result = "tie"
        end
      end
      match.save!
    end
  end

  def update_from_json(tournament_data)
    if tournament_data['participant_number'].present?
      partnum = tournament_data['participant_number'].to_i
      partsize = participants.present? ? participants.size : 0
      if partnum > partsize
        (partnum-partsize).times do |i|
          Participant.create(tournament_id:id)
        end
      end
    end

    if tournament_data['round_number'].present?
      roundnum = tournament_data['round_number'].to_i
      roundsize = rounds.present? ? rounds.size : 0
      if roundnum > roundsize
        (roundnum-roundsize).times do |i|
          Round.create(tournament_id:id)
        end
      end
    end

    update(tournament_data)
  end

end
