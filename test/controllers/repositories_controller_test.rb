require 'test_helper'
require 'octokit'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    VCR.insert_cassette 'github_repositories_response'
  end

  teardown do
    VCR.eject_cassette
  end

  test 'should get index' do
    get repositories_index_url
    assert_response :success
  end

  test 'should search repositories' do
    stub_request(:get, 'https://api.github.com/search/repositories?q=rails')
      .to_return(status: 200, body: {
        'total_count' => 1,
        'items' => [
          {
            'name' => 'Test Repo',
            'full_name' => 'test/test-repo',
            'html_url' => 'https://github.com/test/test-repo',
            "owner": {
              'avatar_url' => 'https://github.com/test/test-repo'
            },
            'description' => 'Dummy description',
            'stargazers_count' => 1,
            'updated_at' => '2023-12-12T00:00:00',
            'watchers_count' => 1
          }
        ]
      }.to_json, headers: { 'Content-Type' => 'application/json' })

    get repositories_search_url(search_term: 'rails')
    assert_response :success
    assert_select 'ul li', 1 # Assuming there's one result in the fixture data
    assert_select 'p', 'Total: 1'
  end

  test 'should handle empty search term' do
    get repositories_search_url(search_term: '')
    assert_response :success
    assert_select 'p', 'Error: Search keyword cannot be empty'
  end

  test "should handle Octokit error" do
    stub_request(:get, 'https://api.github.com/search/repositories?q=rails').to_return(
      status: 404, body: 'Not Found'
    )

    get repositories_search_url(search_term: 'rails')
    assert_response :success
    assert_select 'p', 'Error: GET https://api.github.com/search/repositories?q=rails: 404 - Not Found'
  end

  test 'should validate search term presence' do
    # Simulate a search without a search term
    get repositories_search_url(search_term: nil)
    assert_response :success
    assert_select 'p', 'Error: Search keyword cannot be empty'
  end
end
