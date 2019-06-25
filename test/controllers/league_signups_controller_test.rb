require 'test_helper'

class LeagueSignupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @league_signup = league_signups(:one)
  end

  test "should get index" do
    get league_signups_url
    assert_response :success
  end

  test "should get new" do
    get new_league_signup_url
    assert_response :success
  end

  test "should create league_signup" do
    assert_difference('LeagueSignup.count') do
      post league_signups_url, params: { league_signup: {  } }
    end

    assert_redirected_to league_signup_url(LeagueSignup.last)
  end

  test "should show league_signup" do
    get league_signup_url(@league_signup)
    assert_response :success
  end

  test "should get edit" do
    get edit_league_signup_url(@league_signup)
    assert_response :success
  end

  test "should update league_signup" do
    patch league_signup_url(@league_signup), params: { league_signup: {  } }
    assert_redirected_to league_signup_url(@league_signup)
  end

  test "should destroy league_signup" do
    assert_difference('LeagueSignup.count', -1) do
      delete league_signup_url(@league_signup)
    end

    assert_redirected_to league_signups_url
  end
end
