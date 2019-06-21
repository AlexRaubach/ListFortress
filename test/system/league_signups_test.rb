require "application_system_test_case"

class LeagueSignupsTest < ApplicationSystemTestCase
  setup do
    @league_signup = league_signups(:one)
  end

  test "visiting the index" do
    visit league_signups_url
    assert_selector "h1", text: "League Signups"
  end

  test "creating a League signup" do
    visit league_signups_url
    click_on "New League Signup"

    click_on "Create League signup"

    assert_text "League signup was successfully created"
    click_on "Back"
  end

  test "updating a League signup" do
    visit league_signups_url
    click_on "Edit", match: :first

    click_on "Update League signup"

    assert_text "League signup was successfully updated"
    click_on "Back"
  end

  test "destroying a League signup" do
    visit league_signups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "League signup was successfully destroyed"
  end
end
