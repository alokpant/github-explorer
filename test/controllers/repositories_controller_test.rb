require "test_helper"

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get repositories_index_url
    assert_response :success
  end

  test "should get search" do
    get repositories_search_url
    assert_response :success
  end
end
