require "test_helper"

class Api::V1::SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_subscriptions_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_subscriptions_show_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_subscriptions_create_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_subscriptions_update_url
    assert_response :success
  end
end
