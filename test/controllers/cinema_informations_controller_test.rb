require 'test_helper'

class CinemaInformationsControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get cinema_informations_home_url
    assert_response :success
  end

end
