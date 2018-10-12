class Participant < ApplicationRecord
  belongs_to :tournament
  attr_accessor :squad_url

  def self.get_xws_from_yasb2(query_string)
    url = 'https://yasb2-xws.herokuapp.com/' + query_string
    response = HTTParty.get(url)
    JSON(response.parsed_response)
  end

  def self.get_pilot_name_from_xws(xws_pilot)
    Rails.cache.fetch(xws_pilot) do
      pilot = Pilot.find_by xws: xws_pilot
      return xws_pilot if pilot.nil?
      pilot.name
    end
  end

  def self.get_ship_name_from_xws(xws_ship)
    Rails.cache.fetch(xws_ship) do
      ship = Ship.find_by xws: xws_ship
      return xws_ship if ship.nil?
      ship.name
    end
  end

  def self.get_upgrade_name_from_xws(xws_upgrade)
    Rails.cache.fetch(xws_upgrade) do
      upgrade = Upgrade.find_by xws: xws_upgrade
      return xws_upgrade if upgrade.nil?
      upgrade.name
    end
  end

end
