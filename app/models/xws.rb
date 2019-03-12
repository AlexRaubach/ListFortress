# frozen_string_literal: true

# Converts all xws json to clean strings for display
class XWS
  SKIPPABLE_UPGRADES = ['hardpointcannon', 'hardpointmissile', 'hardpointtorpedo'].freeze

  def self.get_name_from_xws(xws_string, type)
    case type
    when 'pilot'
      XWS.get_pilot_name_from_xws(xws_string)
    when 'upgrade'
      XWS.get_upgrade_name_from_xws(xws_string)
    when 'ship'
      XWS.get_ship_name_from_xws(xws_string)
    end
  end

  def self.get_pilot_name_from_xws(xws_pilot)
    return '?' if xws_pilot.nil?

    Rails.cache.fetch(xws_pilot) do
      pilot = Pilot.find_by xws: xws_pilot
      return xws_pilot if pilot.nil?

      pilot.name
    end
  end

  def self.get_ship_name_from_xws(xws_ship)
    return '?' if xws_ship.nil?

    Rails.cache.fetch(xws_ship) do
      ship = Ship.find_by xws: xws_ship
      return xws_ship if ship.nil?

      ship.name
    end
  end

  def self.get_upgrade_name_from_xws(xws_upgrade)
    return '?' if xws_upgrade.nil?

    Rails.cache.fetch(xws_upgrade) do
      upgrade = Upgrade.find_by xws: xws_upgrade
      return xws_upgrade if upgrade.nil?

      upgrade.name
    end
  end

  def self.formatted_upgrade_string(upgrade_hash)
    string = ''
    upgrade_hash.values.each do |upgrade_array|
      upgrade_array.each do |upgrade_xws|
        next if SKIPPABLE_UPGRADES.include?(upgrade_xws)

        string += ' + ' + XWS.get_upgrade_name_from_xws(upgrade_xws)
      end
    end
    string
  end

  def self.formatted_list(list_json)
    return [] if list_json.blank?

    begin
      list = JSON.parse(list_json)
      output = []
      # output << list.fetch('points', '?') + " Points"
      list['pilots'].each do |pilot_hash|
        string = XWS.get_pilot_name_from_xws(pilot_hash['id'])
        if pilot_hash['upgrades']
          string += XWS.formatted_upgrade_string(pilot_hash['upgrades'])
        end
        output << string
      end
    rescue
      return ['squad error']
    end
    output
  end
end
