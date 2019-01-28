require "application_system_test_case"

class SeasonSevenSurveysTest < ApplicationSystemTestCase
  setup do
    @season_seven_survey = season_seven_surveys(:one)
  end

  test "visiting the index" do
    visit season_seven_surveys_url
    assert_selector "h1", text: "Season Seven Surveys"
  end

  test "creating a Season seven survey" do
    visit season_seven_surveys_url
    click_on "New Season Seven Survey"

    click_on "Create Season seven survey"

    assert_text "Season seven survey was successfully created"
    click_on "Back"
  end

  test "updating a Season seven survey" do
    visit season_seven_surveys_url
    click_on "Edit", match: :first

    click_on "Update Season seven survey"

    assert_text "Season seven survey was successfully updated"
    click_on "Back"
  end

  test "destroying a Season seven survey" do
    visit season_seven_surveys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Season seven survey was successfully destroyed"
  end
end
