# frozen_string_literal: true

# Converts all xws json to clean strings for display
class XWS
  SKIPPABLE_UPGRADES = ['hardpointcannon', 'hardpointmissile', 'hardpointtorpedo'].freeze

  # Card names are looked up hundreds of times per tournament page, so each card table is
  # held in memory as an xws => name hash instead of asking the database or memcached per
  # card. The tables only change when the xwing-data rake tasks run, so a short TTL is
  # enough for running web processes to pick up new cards.
  NAMES_TTL = 10.minutes
  @names = {}

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

    names_for(Pilot).fetch(xws_pilot, xws_pilot)
  end

  def self.get_ship_name_from_xws(xws_ship)
    return '?' if xws_ship.nil?

    names_for(Ship).fetch(xws_ship, xws_ship)
  end

  def self.get_upgrade_name_from_xws(xws_upgrade)
    return '?' if xws_upgrade.blank?

    names_for(Upgrade).fetch(xws_upgrade, xws_upgrade)
  end

  # Returns the xws => name hash for a card model, reloading it once the TTL has passed.
  def self.names_for(model)
    entry = @names[model]
    if entry.nil? || entry[:expires_at] < Time.current
      # Newest rows first so that, for a duplicated xws id, the oldest row wins.
      names = model.where.not(xws: nil).where.not(name: nil).order(id: :desc).pluck(:xws, :name).to_h
      entry = { names: names, expires_at: NAMES_TTL.from_now }
      @names[model] = entry
    end
    entry[:names]
  end

  # Drops the in-memory card names so the next lookup reloads them.
  def self.reset_names!
    @names = {}
  end

  def self.formatted_upgrade_string(upgrade_hash)
    return '' if upgrade_hash.blank?

    string = +''
    upgrade_hash.values.each do |upgrade_array|
      upgrade_array.each do |upgrade_xws|
        next if SKIPPABLE_UPGRADES.include?(upgrade_xws)

        string << ' + ' << XWS.get_upgrade_name_from_xws(upgrade_xws)
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

  def self.faction_icon(list_json)
    return [] if list_json.blank?

    begin
      list = JSON.parse(list_json)
      faction = list['faction']

      return '' if faction.blank?

      faction_icon_name(faction)
    end
  rescue
    ''
  end

  def self.faction_icon_name(xws_faction_name)
    # the xws faction names and font icons don't match up so we have to run them through a switch statement
    case xws_faction_name
    when 'firstorder'
      'firstorder'
    when 'galacticempire'
      'empire'
    when 'rebelalliance'
      'rebel'
    when 'resistance'
      'rebel-outline'
    when 'scumandvillainy'
      'scum'
    when 'galacticrepublic'
      'republic'
    when 'separatistalliance'
      'separatists'
    else
      xws_faction_name
    end
  end
end
