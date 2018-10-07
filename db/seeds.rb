# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Version.create(name: '1.1.0')

faction_list = [
  ['rebelalliance', true],
  ['galacticempire', true],
  ['scumandvillainy', true],
  ['firstorder', false],
  ['resistance', false],
  ['cis', false],
  ['galacticrepublic', false]
]

faction_list.each do |faction_array|
  Faction.create(name: faction_array[0], active: faction_array[1] )
end

format_list = [
  'Extended',
  'Second Edition',
  'Custom',
  'Other'
]

format_list.each do |format_name|
  Format.create(name: format_name)
end

tournamenttype_list = [
  'Store Event',
  'National Championship',
  'Hyperspace Trial',
  'Hyperspace Cup',
  'System Open',
  'World Championship',
  'Casual Event',
  'Other'
]

tournamenttype_list.each do |type_name|
  TournamentType.create(name: type_name)
end
