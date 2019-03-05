require 'test_helper'

class LeagueParticipantControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get league_participant_show_url
    assert_response :success
  end

  test "should get index" do
    get league_participant_index_url
    assert_response :success
  end

end
