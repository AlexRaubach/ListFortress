class Participant < ApplicationRecord
  belongs_to :tournament, counter_cache: true, touch: true
  has_many :matches, as: :player_1
  has_many :matches, as: :player_2
  has_many :matches, as: :winner
  attr_accessor :squad_url

  YASB_TO_XWS_URL = 'https://squad2xws.objectivecat.com/yasb/xws?'.freeze
  PATTERN_ANALYZER_URL = 'https://www.pattern-analyzer.app/api/yasb/xws?'.freeze
  LBN_TO_XWS_URL = 'https://launchbaynext.app/api/xws?'.freeze

  def serializable_hash(options = {})
    super({ only: %i[id,tournament_id,score,swiss_rank,top_cut_rank,mov,sos,dropped,list_points,list_json] }
      .merge(options || {}))
  end

  def self.get_xws_from_url(url)
    begin
      uri = URI(url)

      return get_xws_from_yasb2(uri.query) if ['yasb.app', 'raithos.github.io'].include?(uri.host)
      return get_xws_from_lbn(uri.query) if ['launchbaynext.app'].include?(uri.host)
    end
    nil
  end

  def self.get_xws_from_yasb2(query_string)
    response = HTTParty.get(PATTERN_ANALYZER_URL + query_string)
    return nil if response.code != 200

    JSON(response.parsed_response)
  end

  def self.get_xws_from_lbn(query_string)
    response = HTTParty.get(LBN_TO_XWS_URL + query_string)
    return nil if response.code != 200

    JSON(response.parsed_response)
  end

  def get_name_from_xws(xws_string, type)
    case type
    when 'pilot'
      Participant.get_pilot_name_from_xws(xws_string)
    when 'upgrade'
      Participant.get_upgrade_name_from_xws(xws_string)
    when 'ship'
      Participant.get_ship_name_from_xws(xws_string)
    end
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

  def formatted_upgrade_string(upgrade_hash)
    string = ''
    upgrade_hash.values.each do |upgrade_array|
      upgrade_array.each do |upgrade_xws|
        string += ' + ' + Participant.get_upgrade_name_from_xws(upgrade_xws)
      end
    end
    string
  end

  def formatted_list
    return [] if self.list_json.blank?

    begin
      list = JSON.parse(self.list_json)
      output = []
      # output << list.fetch('points', '?') + " Points"
      list['pilots'].each do |pilot_hash|
        string = Participant.get_pilot_name_from_xws(pilot_hash['id'])
        if pilot_hash['upgrades']
          string += formatted_upgrade_string(pilot_hash['upgrades'])
        end
        output << string
      end
    rescue
      return ['squad error']
    end
    output
  end

  def update_with_xws(participant_data)
    if participant_data['squad_url'].present?
      participant_data['list_json'] = Participant.get_xws_from_url(participant_data['squad_url'])
    end

    update(participant_data)
  end
end
