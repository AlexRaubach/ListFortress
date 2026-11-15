require 'test_helper'

class RoundsControllerTest < ActionDispatch::IntegrationTest
  test 'show lists each match with player and winner names' do
    get round_url(rounds(:store_champ_swiss_1))

    assert_response :success
    assert_select 'tbody tr, table tr' do
      assert_select 'td', text: 'Alice', minimum: 2
      assert_select 'td', text: 'Bob'
    end
  end

  test 'show names players for matches stored without a player type' do
    round = rounds(:store_champ_swiss_1)
    Match.create!(round: round, player1_id: participants(:bob).id, winner_id: participants(:bob).id)

    get round_url(round)

    assert_select 'td', text: 'Bob', minimum: 3
  end

  test 'index is paginated' do
    get rounds_url(format: :json)
    assert_response :success

    get rounds_url(format: :json, page: 1000)
    assert_equal [], response.parsed_body
  end

  test 'create via json adds a round with empty matches' do
    tournament = tournaments(:store_champ)

    assert_difference -> { tournament.rounds.count } => 1, -> { Match.count } => 4 do
      post rounds_url(format: :json),
           params: { round: { tournament_id: tournament.id, roundtype_id: Roundtype::SWISS_ID, round_number: 2, match_number: 4 } },
           as: :json
    end

    assert_response :created
  end

  test 'update via json reports success' do
    round = rounds(:store_champ_swiss_1)

    patch round_url(round, format: :json), params: { round: { round_number: 5 } }, as: :json

    assert_response :success
    assert_equal round.id, response.parsed_body['id']
    assert_equal 5, round.reload.round_number
  end

  test 'update cannot move a round to another tournament' do
    round = rounds(:store_champ_swiss_1)

    patch round_url(round, format: :json), params: { round: { tournament_id: tournaments(:hyperspace).id } }, as: :json

    assert_equal tournaments(:store_champ), round.reload.tournament
  end
end
