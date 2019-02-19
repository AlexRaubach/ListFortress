desc 'Creates S7 and all the divisions and matches'
task generate_season_seven_matches: :environment do
  DIVISION_NAMES = [
    ['Coruscant'],
    ['Alderaan', 'Corellia', 'Kuat'],
    ['Chardaan', 'Kashyyyk', 'Myrkr', 'Nal Hutta', 'Manaan'],
    ['Bespin', 'Dagobah', 'Tatooine',
     'Endor', 'Dantooine', 'Hoth',
     'Yavin', 'Kamino', 'Mandalore'],
    ['Jakku', 'Nkllon', 'Csilla',
     'Celwiss', 'Ilum', 'Plunder Moon',
     'Bakura', 'The Redoubt', 'Nirauan',
     'Lwhekk']
    ].freeze

  season = Season.create(season_number: 7)

  DIVISION_NAMES.each_with_index do |tier_data, i|


  end

end
