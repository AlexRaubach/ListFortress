require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  XWS_BODY = { faction: 'rebelalliance', pilots: [{ id: 'lukeskywalker', ship: 't65xwing' }] }.to_json
  # The converters answer with JSON, which HTTParty parses before the model re-serializes it.
  JSON_HEADERS = { 'Content-Type' => 'application/json' }.freeze

  test 'formatted_list renders the squad' do
    assert_equal ['Luke Skywalker + Proton Torpedoes'], participants(:alice).formatted_list
  end

  test 'formatted_list is empty without a squad' do
    assert_equal [], participants(:bob).formatted_list
  end

  test 'creating a participant increments the tournament counter cache' do
    tournament = tournaments(:store_champ)

    assert_difference -> { tournament.reload.participants_count }, 1 do
      Participant.create!(tournament: tournament, name: 'Newcomer')
    end
  end

  test 'get_xws_from_url converts YASB links through pattern analyzer' do
    stub = stub_request(:get, "#{Participant::PATTERN_ANALYZER_URL}f=Rebel%20Alliance&d=v8ZsZ200")
           .to_return(status: 200, body: XWS_BODY, headers: JSON_HEADERS)

    result = Participant.get_xws_from_url('https://yasb.app/?f=Rebel%20Alliance&d=v8ZsZ200')

    assert_requested stub
    assert_equal 'lukeskywalker', JSON.parse(result).dig('pilots', 0, 'id')
  end

  test 'get_xws_from_url converts Launch Bay Next links' do
    stub = stub_request(:get, "#{Participant::LBN_TO_XWS_URL}lbx=abc123")
           .to_return(status: 200, body: XWS_BODY, headers: JSON_HEADERS)

    Participant.get_xws_from_url('https://launchbaynext.app/print?lbx=abc123')

    assert_requested stub
  end

  test 'get_xws_from_url returns nil when the converter fails' do
    stub_request(:get, /pattern-analyzer/).to_return(status: 500)

    assert_nil Participant.get_xws_from_url('https://yasb.app/?f=Rebel%20Alliance&d=v8ZsZ200')
  end

  test 'get_xws_from_url ignores unsupported squad builders' do
    assert_nil Participant.get_xws_from_url('https://example.com/squad?id=1')
  end

  test 'update_with_xws replaces list_json from a squad url' do
    stub_request(:get, /pattern-analyzer/).to_return(status: 200, body: XWS_BODY, headers: JSON_HEADERS)
    participant = participants(:bob)

    assert participant.update_with_xws('squad_url' => 'https://yasb.app/?f=Rebel%20Alliance&d=v8ZsZ200', 'score' => 3)

    participant.reload
    assert_equal 3, participant.score
    assert_equal ['Luke Skywalker'], participant.formatted_list
  end
end
