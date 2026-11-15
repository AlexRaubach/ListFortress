require 'test_helper'

class XWSTest < ActiveSupport::TestCase
  test 'formatted_list renders pilot names with upgrades' do
    list = participants(:alice).list_json

    assert_equal ['Luke Skywalker + Proton Torpedoes'], XWS.formatted_list(list)
  end

  test 'formatted_list falls back to the xws id for unknown cards' do
    list = { pilots: [{ id: 'mysterypilot', upgrades: { talent: ['mysterytalent'] } }] }.to_json

    assert_equal ['mysterypilot + mysterytalent'], XWS.formatted_list(list)
  end

  test 'formatted_list skips hardpoint placeholder upgrades' do
    list = { pilots: [{ id: 'lukeskywalker', upgrades: { hardpoint: ['hardpointcannon'], torpedo: ['protontorpedoes'] } }] }.to_json

    assert_equal ['Luke Skywalker + Proton Torpedoes'], XWS.formatted_list(list)
  end

  test 'formatted_list is empty for a blank list' do
    assert_equal [], XWS.formatted_list(nil)
    assert_equal [], XWS.formatted_list('')
  end

  test 'formatted_list reports malformed squads instead of raising' do
    assert_equal ['squad error'], XWS.formatted_list('not json')
    assert_equal ['squad error'], XWS.formatted_list({ faction: 'rebelalliance' }.to_json)
  end

  test 'name lookups return a placeholder for nil' do
    assert_equal '?', XWS.get_pilot_name_from_xws(nil)
    assert_equal '?', XWS.get_ship_name_from_xws(nil)
    assert_equal '?', XWS.get_upgrade_name_from_xws('')
  end

  test 'get_name_from_xws dispatches on type' do
    assert_equal 'Luke Skywalker', XWS.get_name_from_xws('lukeskywalker', 'pilot')
    assert_equal 'T-65 X-wing', XWS.get_name_from_xws('t65xwing', 'ship')
    assert_equal 'Proton Torpedoes', XWS.get_name_from_xws('protontorpedoes', 'upgrade')
  end

  test 'faction_icon maps xws factions onto icon font names' do
    {
      'galacticempire' => 'empire',
      'rebelalliance' => 'rebel',
      'resistance' => 'rebel-outline',
      'scumandvillainy' => 'scum',
      'firstorder' => 'firstorder',
      'galacticrepublic' => 'republic',
      'separatistalliance' => 'separatists'
    }.each do |faction, icon|
      assert_equal icon, XWS.faction_icon({ faction: faction }.to_json), faction
    end
  end

  test 'faction_icon handles missing or broken data' do
    assert_equal [], XWS.faction_icon(nil)
    assert_equal '', XWS.faction_icon({ pilots: [] }.to_json)
    assert_equal '', XWS.faction_icon('{broken')
  end

  test 'name lookups are served from memory after the first call' do
    XWS.get_pilot_name_from_xws('lukeskywalker')

    assert_no_queries do
      assert_equal 'Luke Skywalker', XWS.get_pilot_name_from_xws('lukeskywalker')
      assert_equal 'mysterypilot', XWS.get_pilot_name_from_xws('mysterypilot')
    end
  end

  test 'card names are reloaded once the ttl has passed' do
    XWS.get_pilot_name_from_xws('lukeskywalker')
    Pilot.create!(xws: 'newpilot', name: 'New Pilot')

    assert_equal 'newpilot', XWS.get_pilot_name_from_xws('newpilot')
    travel XWS::NAMES_TTL + 1.second do
      assert_equal 'New Pilot', XWS.get_pilot_name_from_xws('newpilot')
    end
  end
end
