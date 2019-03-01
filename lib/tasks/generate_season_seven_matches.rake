desc 'Creates S7 and all the divisions and matches'
task generate_season_seven_matches: :environment do
  DIVISION_NAMES = [
    ['Coruscant'],
    ['Alderaan', 'Corellia', 'Kuat'],
    ['Chardaan', 'Kashyyyk', 'Myrkr', 'Nal Hutta', 'Manaan'],
    ['Bespin', 'Dagobah', 'Tatooine',
     'Endor', 'Dantooine', 'Hoth',
     'Yavin', 'Kamino', 'Mon Calamari', 'Mandalore'],
    ['Jakku', 'Nkllon', 'Csilla',
     'Celwiss', 'Ilum', 'Plunder Moon',
     'Bakura', 'The Redoubt', 'Nirauan',
     'kariek', 'Lwhekk']
    ].freeze

  season = Season.create(season_number: 7)

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

  csv_text = File.open("#{Rails.root}/public/s7_divisions.csv")
  csv = CSV.parse(csv_text)
  csv.each do |user_info|
    user_id = user_info[0]
    # name = user_info[1]
    division_tier = user_info[2]
    division_letter = user_info[3]

    league_participant = LeagueParticipant.create(user_id: user_id)

    division = Division.find_by(
      tier: division_tier,
      letter: division_letter,
      season_id: season.id
    )

    if division.nil?
      puts "Nil division " + division_tier + division_letter
      next
    end

    division.add_participant(league_participant)
  end
end
