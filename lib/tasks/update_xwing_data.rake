desc 'Updates XWS from xwingdata2'
task update_xwing_data: :environment do

  def parse_upgrades(file_name)
    json = get_json_from_file(file_name)

    json.each do |upgrade_data|
      upgrade = Upgrade.where(xws: upgrade_data['xws']).first_or_initialize
      upgrade.name = upgrade_data['name']
      upgrade.limited = upgrade_data['limited']
      upgrade.cost = upgrade_data.dig('cost', 'value')

      if upgrade_data['sides']&.length&.positive?
        upgrade.ffg = upgrade_data['sides'][0]['ffg']
        upgrade.upgrade_type = upgrade_data['sides'][0]['type']
        upgrade.image = upgrade_data['sides'][0]['image']
      end

      upgrade.save
    end
  end

  def parse_ships_and_pilots(json_file)
    ship_json = get_json_from_file(json_file)

    ship = Ship.where(xws: ship_json['xws']).first_or_initialize
    ship.name = ship_json['name']
    ship.size = ship_json['size']
    ship.ffg = ship_json['ffg']
    ship.save

    return if ship_json['pilots'].blank?

    ship_json['pilots'].each do |pilot_json|
      pilot = Pilot.where(xws: pilot_json['xws']).first_or_initialize

      pilot.name = pilot_json['name']
      pilot.caption = pilot_json['caption']
      pilot.initiative = pilot_json['initiative']
      pilot.limited = pilot_json['limited']
      pilot.cost = pilot_json['cost']
      pilot.ffg = pilot_json['ffg']
      pilot.ship_id = ship.id
      pilot.image = pilot_json['image']
      pilot.ability = pilot_json['ability']
      pilot.save
    end
  end

  def get_json_from_file(file_name)
    file = File.read(file_name)
    JSON.parse(file)
  end

  # system 'cd xwing-data2 && git checkout master && git pull && cd ..'

  upgrade_file_names = Dir.glob("#{Rails.root}/xwing-data2/data/upgrades/*.json")
  upgrade_file_names.each do |upgrade_file|
    parse_upgrades(upgrade_file)
  end

  pilot_file_names = Dir.glob("#{Rails.root}/xwing-data2/data/pilots/**/*.json")
  pilot_file_names.each do |pilot_file|
    parse_ships_and_pilots(pilot_file)
  end
end
