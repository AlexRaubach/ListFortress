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
     'Lwhekk']
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

  csv = CSV.parse("#{Rails.root}/public/s7_divisions.csv")
  csv.each do |user_info|
    
  end

end
