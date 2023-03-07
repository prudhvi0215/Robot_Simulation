require "test_helper"

class Api::Robot::0::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_robot_0_orders_create_url
    assert_response :success
  end
end
