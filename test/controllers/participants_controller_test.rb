require 'test_helper'

# Participants are mostly edited through JSON by external tools, so cover that path.
class ParticipantsControllerTest < ActionDispatch::IntegrationTest
  test 'index is paginated' do
    get participants_url(format: :json)
    assert_response :success
    assert_includes response.parsed_body.map { |row| row['name'] }, 'Alice'

    get participants_url(format: :json, page: 1000)
    assert_equal [], response.parsed_body
  end

  test 'show as json' do
    get participant_url(participants(:alice), format: :json)

    assert_response :success
    assert_equal 'Alice', response.parsed_body['name']
  end

  test 'show returns 404 for an unknown participant' do
    get participant_url(id: 0)

    assert_response :not_found
  end

  test 'edit page renders' do
    get edit_participant_url(participants(:alice))

    assert_response :success
  end

  test 'update via json without a csrf token' do
    participant = participants(:bob)

    patch participant_url(participant, format: :json),
          params: { participant: { name: 'Robert', score: 4, dropped: true } }, as: :json

    assert_response :success
    participant.reload
    assert_equal ['Robert', 4, true], [participant.name, participant.score, participant.dropped]
  end

  test 'update with a squad url converts it to xws' do
    stub_request(:get, /launchbaynext\.app\/api\/xws/)
      .to_return(status: 200, body: { pilots: [{ id: 'lukeskywalker' }] }.to_json,
                 headers: { 'Content-Type' => 'application/json' })
    participant = participants(:bob)

    patch participant_url(participant), params: { participant: { squad_url: 'https://launchbaynext.app/print?lbx=abc' } }

    assert_redirected_to tournament_url(participant.tournament)
    assert_equal ['Luke Skywalker'], participant.reload.formatted_list
  end

  test 'create via json' do
    assert_difference -> { tournaments(:store_champ).reload.participants_count }, 1 do
      post participants_url(format: :json),
           params: { participant: { name: 'Newcomer', tournament_id: tournaments(:store_champ).id } }, as: :json
    end

    assert_response :created
  end

  test 'update cannot move a participant to another tournament' do
    participant = participants(:bob)

    patch participant_url(participant, format: :json),
          params: { participant: { tournament_id: tournaments(:hyperspace).id } }, as: :json

    assert_equal tournaments(:store_champ), participant.reload.tournament
  end
end
