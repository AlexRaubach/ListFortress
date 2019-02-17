desc 'Load historical league matches from List Juggler'
task load_matches_from_lj: :environment do
  SEASON_IDS = [2, 3, 5, 6, 7, 8].freeze
  BASE_URL = 'http://lists.starwarsclubhouse.com/api/v1/vassal_league_matches/'.freeze

  SEASON_IDS.each do |season_number|
    url = BASE_URL + season_number.to_s
    response = HTTParty.get(url)
    next unless response.code == 200

    season_matches = response.parsed_response

    season_matches['matches'].each do |match_json|
      match = Match.new
      match.locked = true
      match.logfile_url = match_json['logfile_url']
      match.scheduled_time = match_json['scheduled_datetime']

      match.player1 = LeagueParticipant.find_by(list_juggler_id: match_json.dig('player1', 'id'))
      match.player1_xws = match_json.dig('player1', 'xws')
      match.player1_points = match_json.dig('player1', 'score')

      match.player2 = LeagueParticipant.find_by(list_juggler_id: match_json.dig('player2', 'id'))
      match.player2_xws = match_json.dig('player2', 'xws')
      match.player2_points = match_json.dig('player2', 'score')

      if match_json['state'] == 'complete' && match.player2_points && match.player1_points
        if match.player2_points > match.player1_points
          match.winner = match.player2
        elsif match.player1_points > match.player2_points
          match.winner = match.player1
        end
      end

      match.save
      p match unless match.valid?
    end
  end
end
