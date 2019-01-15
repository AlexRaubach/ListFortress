# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Version.create(name: '1.1.0')

# TODO load factions from xwingdata json instead
faction_list = [
  ['Rebel Alliance', 'rebelalliance', 1],
  ['Galactic Empire', 'galacticempire', 2],
  ['Scum and Villainy', 'scumandvillainy', 3],
  ['First Order', 'firstorder', 4],
  ['Resistance', 'resistance', 5],
  ['separatistalliance', 6],
  ['galacticrepublic', 7]
]

faction_list.each do |faction_array|
  Faction.create(xws: faction_array[0], name: faction_array[1], ffg: faction_array[2] )
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

def parse_ships_and_pilots(json_file)
  ship_json = get_json_from_file(json_file)

  ship = Ship.create(
    name: ship_json['name'],
    xws: ship_json['xws'],
    size: ship_json['size'],
    ffg: ship_json['ffg']
    )

  return if ship_json['pilots'].blank?

  ship_json['pilots'].each do |pilot_json|
    Pilot.create(
      name: pilot_json['name'],
      caption: pilot_json['caption'],
      initiative: pilot_json['initiative'],
      limited: pilot_json['limited'],
      cost: pilot_json['cost'],
      xws: pilot_json['xws'],
      ffg: pilot_json['ffg'],
      ship_id: ship.id,
      image: pilot_json['image'],
      ability: pilot_json['ability']
    )
  end
end

def parse_upgrades(file_name)
  json = get_json_from_file(file_name)

  json.each do |upgrade_data|
    upgrade = Upgrade.new(
      name: upgrade_data['name'],
      xws: upgrade_data['xws'],
      limited: upgrade_data['limited']
    )

    if upgrade_data['sides'] && upgrade_data['sides'].length.positive?
      upgrade.ffg = upgrade_data['sides'][0]['ffg']
      upgrade.upgrade_type =  upgrade_data['sides'][0]['type']
      upgrade.image = upgrade_data['sides'][0]['image']
    end

    if upgrade_data['cost']
      upgrade.cost = upgrade_data['cost']['value']
    end

    upgrade.save
  end
end

def get_json_from_file(file_name)
  file = File.read(file_name)
  JSON.parse(file)
end

upgrade_file_names = Dir.glob("#{Rails.root}/xwing-data2/data/upgrades/*.json")
upgrade_file_names.each do |upgrade_file| 
  parse_upgrades(upgrade_file)
end

pilot_file_names = Dir.glob("#{Rails.root}/xwing-data2/data/pilots/**/*.json")
pilot_file_names.each do |pilot_file|
  parse_ships_and_pilots(pilot_file)
end
