desc 'Creates S1001 and all the divisions and matches'
task generate_league_matches_s1000: :environment do
  DIVISION_NAMES = [
    ['Black Sun', 'Crimson Dawn']
  ].freeze

  season = Season.create(season_number: 1002, name: 'X-Wing Hungarian Vassal League Season Three', active: true)

  DIVISION_NAMES.each_with_index do |tier_data, tier_number|
    tier_data.each_with_index do |tier_name, division_number|
      Division.create(
        season_id: season.id,
        tier: tier_number + 1,
        name: tier_name,
        letter: (division_number + 65).chr
      )
    end
  end

  csv_text = File.open("#{Rails.root}/public/HVL_1002.csv")
  csv = CSV.parse(csv_text)
  csv.each do |user_info|
    name = user_info[0]
    # name = user_info[1]
    division_tier = user_info[1]
    division_letter = user_info[2]

    next if name.nil?

    league_participant = LeagueParticipant.create(list_juggler_name: name)

    division = Division.find_by(
      tier: division_tier,
      letter: division_letter,
      season_id: season.id
    )

    if division.nil?
      puts 'Nil division ' + division_tier.to_s + division_letter.to_s
      next
    end

    division.add_participant(league_participant)
  end
end

def add_to_league(season_number, name, div_tier, div_letter)
  season = Season.find_by(season_number: season_number)

  division = Division.find_by(
    tier: div_tier,
    letter: div_letter,
    season_id: season.id
  )

  puts 'Nil division ' + div_tier.to_S + div_letter.to_s if division.nil?

  league_participant = LeagueParticipant.create(list_juggler_name: name)

  division.add_participant(league_participant)
end
