desc 'Load historical league promotion status from List Juggler'
task load_promotion_status_from_lj: :environment do
  SEASON_IDS = [2, 3, 5, 6, 7, 8].freeze
  BASE_URL = 'http://lists.starwarsclubhouse.com/api/v1/vassal_league_ranking/'

  SEASON_IDS.each do |season_number|
    35.times do |i|
      url = BASE_URL + season_number.to_s + '/tier/' + i.to_s

      response = HTTParty.get(url)
      next unless response.code == 200

      division_rankings = response.parsed_response
      next if division_rankings.empty?

      puts 'Parsing Season ' + season_number.to_s + ' tier ' + i.to_s
      division_rankings['division_ranking'].each do |division|
        count = division['rankings'].count
        next if count.zero?

        division['rankings'].each do |rank_hash|
          if [0, 1].include?(rank_hash['rank'])
            player = LeagueParticipant.find_by(list_juggler_id: rank_hash['id'])
            player.promotion = 1
            player.save
          elsif rank_hash['rank'] == count || rank_hash['rank'] == count - 1
            player = LeagueParticipant.find_by(list_juggler_id: rank_hash['id'])
            player.promotion = -1
            player.save
          end
        end
      end
    end
  end
end
