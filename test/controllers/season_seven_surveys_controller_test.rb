require 'test_helper'

class SeasonSevenSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @season_seven_survey = season_seven_surveys(:one)
  end

  test "should get index" do
    get season_seven_surveys_url
    assert_response :success
  end

  test "should get new" do
    get new_season_seven_survey_url
    assert_response :success
  end

  test "should create season_seven_survey" do
    assert_difference('SeasonSevenSurvey.count') do
      post season_seven_surveys_url, params: { season_seven_survey: {  } }
    end

    assert_redirected_to season_seven_survey_url(SeasonSevenSurvey.last)
  end

  test "should show season_seven_survey" do
    get season_seven_survey_url(@season_seven_survey)
    assert_response :success
  end

  test "should get edit" do
    get edit_season_seven_survey_url(@season_seven_survey)
    assert_response :success
  end

  test "should update season_seven_survey" do
    patch season_seven_survey_url(@season_seven_survey), params: { season_seven_survey: {  } }
    assert_redirected_to season_seven_survey_url(@season_seven_survey)
  end

  test "should destroy season_seven_survey" do
    assert_difference('SeasonSevenSurvey.count', -1) do
      delete season_seven_survey_url(@season_seven_survey)
    end

    assert_redirected_to season_seven_surveys_url
  end
end
