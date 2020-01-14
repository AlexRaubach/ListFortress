desc 'Creates S8 and all the divisions and matches'
task generate_league_matches: :environment do
  DIVISION_NAMES = [
    ['Coruscant'],
    ['Alderaan', 'Corellia', 'Kuat'],
    ['Chardaan', 'Kashyyyk', 'Myrkr', 'Nal Hutta', 'Manaan'],
    ['Bespin', 'Dagobah', 'Tatooine',
     'Endor', 'Dantooine', 'Hoth', 'Yavin'
      # , 'Kamino', 'Mon Calamari', 'Mandalore'
    ],
    # ['Jakku', 'Nkllon', 'Csilla',
    #  'Celwiss', 'Ilum', 'Plunder Moon', 'Bakura'
    # #  , 'The Redoubt', 'Nirauan',
    # #  'Kariek', 'Lwhekk'
    # ]
  ].freeze

  season = Season.create(season_number: 9, name: 'X-Wing Vassal League Season Nine')

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

  csv_text = File.open("#{Rails.root}/public/s9.csv")
  csv = CSV.parse(csv_text)
  csv.each do |user_info|
    user_id = user_info[0]
    # name = user_info[1]
    division_tier = user_info[1]
    division_letter = user_info[2]

    league_participant = LeagueParticipant.create(user_id: user_id)

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

def add_to_league(season_number, user_id, div_tier, div_letter)
  season = Season.find_by(season_number: season_number)

  division = Division.find_by(
    tier: div_tier,
    letter: div_letter,
    season_id: season.id
  )

  puts 'Nil division ' + div_tier.to_S + div_letter.to_s if division.nil?

  league_participant = LeagueParticipant.create(user_id: user_id)

  division.add_participant(league_participant)
end
