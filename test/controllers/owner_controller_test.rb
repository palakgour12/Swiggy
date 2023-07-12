require "test_helper"

class OwnerControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get owner_login_url
    assert_response :success
  end

  test "should get create" do
    get owner_create_url
    assert_response :success
  end
end
