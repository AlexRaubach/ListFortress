require 'test_helper'

class SeasonsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get seasons_index_url
    assert_response :success
  end

  test "should get show" do
    get seasons_show_url
    assert_response :success
  end

end
