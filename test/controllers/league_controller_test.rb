require 'test_helper'

# Smoke tests for the league pages, the seasons API and Slack sign in.
class LeagueControllerTest < ActionDispatch::IntegrationTest
  test 'public league pages render' do
    [league_url, seasons_url, season_url(seasons(:current).season_number), division_url(divisions(:current_1a)),
     league_participant_url(league_participants(:player_current)), about_url].each do |url|
      get url
      assert_response :success, url
    end
  end

  test 'season csv export' do
    get season_url(seasons(:previous).season_number, format: :csv)

    assert_response :success
    assert_equal ['player'], CSV.parse(response.body, headers: true).map { |r| r['name'] }
  end

  test 'seasons api' do
    get api_v1_seasons_url

    assert_response :success
    assert_equal [11, 12], response.parsed_body.map { |s| s['season_number'] }
  end

  test 'signing in with slack creates a user the first time' do
    OmniAuth.config.mock_auth[:slack] = OmniAuth::AuthHash.new(
      provider: 'slack', uid: 'U999', info: { name: 'Biggs', nickname: 'biggs', user_id: 'U999' }
    )

    assert_difference -> { User.count } => 1, -> { Identity.count } => 1 do
      get '/auth/slack/callback'
    end
    assert_redirected_to '/league'
    assert_equal 'Thanks for registering', flash[:notice]

    # Signing in again reuses the same user.
    get logout_url
    assert_no_difference -> { User.count } do
      get '/auth/slack/callback'
    end
    assert_equal 'Signed in!', flash[:notice]
  end

  test 'the me page requires sign in' do
    get me_url
    assert_redirected_to '/league'

    sign_in_as users(:player)
    get me_url
    assert_response :success
  end

  test 'updating profile details' do
    sign_in_as users(:player)

    post me_url, params: { display_name: 'renamed', full_name: 'Renamed Player', city: 'Odense', country: 'Denmark' }

    assert_redirected_to '/me'
    user = users(:player).reload
    assert_equal 'renamed', user.display_name
    assert_equal 'Odense', user.address.city
  end
end
