require 'test_helper'

class TournamentsControllerTest < ActionDispatch::IntegrationTest
  def tournament_params(**overrides)
    {
      tournament: {
        name: 'Fresh Event', date: '2025-06-01', country: 'Canada',
        format_id: formats(:second_edition).id, tournament_type_id: tournament_types(:store_event).id
      }.merge(overrides)
    }
  end

  test 'index lists tournaments' do
    get root_url

    assert_response :success
    assert_select 'body', /Store Championship/
    assert_select 'body', /Copenhagen Hyperspace Trial/
  end

  test 'index applies filters' do
    get tournaments_url, params: { country: 'Denmark' }

    assert_response :success
    assert_select 'body', /Copenhagen Hyperspace Trial/
    assert_select 'body', { text: /Store Championship/, count: 0 }
  end

  test 'show renders participants and their squads' do
    get tournament_url(tournaments(:store_champ))

    assert_response :success
    assert_select 'h1', /Store Championship/
    assert_select '#tournament_participants', /Alice/
    assert_select '#tournament_participants', /Luke Skywalker \+ Proton Torpedoes/
  end

  test 'show returns 404 for an unknown tournament' do
    get tournament_url(id: 0)

    assert_response :not_found
  end

  test 'show exports csv' do
    get tournament_url(tournaments(:store_champ), format: :csv)

    assert_response :success
    assert_equal 'text/csv', response.media_type
    assert_equal %w[Alice Bob], CSV.parse(response.body, headers: true).map { |r| r['playerName'] }
  end

  test 'json index' do
    get tournaments_url(format: :json)
    assert_response :success
    assert_equal 2, response.parsed_body.size
  end

  test 'rss feed' do
    get tournament_feed_url(format: :rss)

    assert_response :success
    assert_includes response.body, 'Copenhagen Hyperspace Trial'
  end

  test 'new and edit forms render' do
    get new_tournament_url
    assert_response :success

    get edit_tournament_url(tournaments(:store_champ))
    assert_response :success
  end

  test 'create with a player count makes empty participants' do
    assert_difference -> { Tournament.count } => 1, -> { Participant.count } => 8 do
      post tournaments_url, params: tournament_params(participant_number: 8)
    end

    tournament = Tournament.order(:id).last
    assert_redirected_to tournament_url(tournament)
    assert_equal 8, tournament.participants_count
  end

  test 'create imports cryodex json' do
    assert_difference -> { Participant.count } => 3, -> { Round.count } => 2 do
      post tournaments_url, params: tournament_params(cryodex_json: fixture_file('listjuggler_tournament.json'))
    end

    assert_response :redirect
  end

  test 'create discards tournaments with fewer than two players' do
    assert_no_difference -> { Tournament.count } do
      post tournaments_url, params: tournament_params(participant_number: 1)
    end

    assert_response :success
    assert_select '.alert', /Something isn't right/
  end

  test 'create discards tournaments without a date' do
    assert_no_difference -> { Tournament.count } do
      post tournaments_url, params: tournament_params(date: '', participant_number: 4)
    end
  end

  test 'update changes tournament details' do
    tournament = tournaments(:store_champ)

    patch tournament_url(tournament), params: { tournament: { name: 'Store Champs 2024', participant_number: 3 } }

    assert_redirected_to tournament_url(tournament)
    assert_equal 'Store Champs 2024', tournament.reload.name
    assert_equal 3, tournament.participants.count
  end

  test 'update via json' do
    tournament = tournaments(:store_champ)

    patch tournament_url(tournament, format: :json), params: { tournament: { location: 'Main St Games' } }, as: :json

    assert_response :success
    assert_equal 'Main St Games', tournament.reload.location
  end

  test 'only admins can delete tournaments' do
    tournament = tournaments(:store_champ)

    delete tournament_url(tournament)
    assert Tournament.exists?(tournament.id)

    sign_in_as users(:player)
    delete tournament_url(tournament)
    assert Tournament.exists?(tournament.id)

    sign_in_as users(:admin)
    delete tournament_url(tournament)
    assert_redirected_to tournaments_url
    assert_not Tournament.exists?(tournament.id)
  end
end
