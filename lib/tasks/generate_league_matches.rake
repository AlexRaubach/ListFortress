desc 'Creates a league season, divisions and matches'
task generate_league_matches: :environment do
  division_names = [
    ['Coruscant'],
    [
      'Alderaan', 'Corellia'
      # , 'Kuat'
    ],
    [ # Tier 3
      'Chardaan', 'Kashyyyk', 'Myrkr',
      'Nal Hutta', 'Manaan', 'Ord Mantell'
    ],
    # [ # Tier 4
    #   'Bespin', 'Dagobah', 'Tatooine',
    #   'Endor', 'Dantooine', 'Hoth'
    #   # , 'Yavin' , 'Kamino', 'Mon Calamari', 'Mandalore'
    # ]
    # ,[    # Tier Five
    #  'Jakku', 'Nkllon', 'Csilla',
    #  'Celwiss', 'Ilum', 'Plunder Moon', 'Bakura'
    # #  , 'The Redoubt', 'Nirauan',
    # #  'Kariek', 'Lwhekk'
    # ]
  ].freeze

  season = Season.create(season_number: 11, name: 'X-Wing Vassal League Season Eleven', active: true)

  division_names.each_with_index do |tier_data, tier_number|
    tier_data.each_with_index do |tier_name, division_number|
      Division.create(
        season_id: season.id,
        tier: tier_number + 1,
        name: tier_name,
        letter: (division_number + 65).chr
      )
    end
  end

  csv_text = File.open("#{Rails.root}/public/s11.csv")
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
      puts "Nil division  #{division_tier} #{division_letter}"
      next
    end

    division.add_participant(league_participant)
  end
end

# This is sample code used to add late signups without the batch process I use normally
# you can fill in your new player array and then paste everything into the console.

# new_players = [
#   [110, 3, 'E'],
#   [655, 3, 'A']
# ]

# current_season_number = 11

# new_players.each do |p|
#   Season.add_participant(current_season_number, p[0], p[1], p[2])
# end
