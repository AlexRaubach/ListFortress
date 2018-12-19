desc 'Load historical tournament data from List Juggler'
task load_participants_from_lj: :environment do

  SEASON_IDS = [2, 3, 5, 6, 7, 8].freeze

  SEASON_IDS.each_with_index do |season_number, i|
    url = 'http://lists.starwarsclubhouse.com/api/v1/vassal_league/' + season_number.to_s 
    response = HTTParty.get(url)
    return false unless response.code == 200

    season_json = response.parsed_response

    season = Season.create(
      active: false, 
      sign_up_active: false, 
      locked: true, 
      season_number: i + 1,
      name: season_json['name']
    )

    season_json['tiers'].each do |tier|
      tier['divisions'].each do |division_hash|
        case tier['tier_name']
        when 'deepcore', 'deepcore' + (i + 1).to_s
          tier_number = 1
        when 'coreworlds', 'coreworlds' + (i + 1).to_s
          tier_number = 2
        when 'innerrim', 'innerrim' + (i + 1).to_s
          tier_number = 3
        when 'outerrim', 'outerrim' + (i + 1).to_s
          tier_number = 4
        when 'unknownreaches', 'unknownreaches' + (i + 1).to_s
          tier_number = 5
        end

        division = Division.create(
          name: division_hash['name'],
          season_id: season.id,
          tier: tier_number
        )

        division_hash['players'].each do |player_hash|
          LeagueParticipant.create(
            list_juggler_name: player_hash['name'],
            list_juggler_id: player_hash['player_id'],
            division_id: division.id
          )
        end
      end
    end
  end
end
