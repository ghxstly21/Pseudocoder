require "test_helper"

class CompilationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get compilations_index_url
    assert_response :success
  end

  test "should get create" do
    get compilations_create_url
    assert_response :success
  end
end
