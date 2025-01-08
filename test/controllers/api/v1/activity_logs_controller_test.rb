require "test_helper"

class Api::V1::ActivityLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_activity_logs_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_activity_logs_show_url
    assert_response :success
  end
end
