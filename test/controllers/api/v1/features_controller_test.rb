require "test_helper"

class Api::V1::FeaturesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_features_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_features_show_url
    assert_response :success
  end
end
