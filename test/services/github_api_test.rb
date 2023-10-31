require 'minitest/autorun'
require 'octokit'
require_relative '../../app/services/github_api'

class GithubApiTest < Minitest::Test
  def setup
    @github_api = GithubApi.new
  end

  def test_search_repositories_with_valid_query
    name = 'Test Repo'
    # Mock the Octokit.search_repositories method to return a predefined value
    Octokit.stub :search_repositories, {
      'total_count' => 1,
      'items' => [
        {
          'name' => name,
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
    } do
      query = 'example_query'
      result = @github_api.search_repositories(query)

      first_item = result['items'].first
      total_count = result['total_count']
      assert_equal 1, total_count
      assert_includes first_item['name'], name
    end
  end

  def test_search_repositories_with_valid_query_multiple_results
    name = 'Test Repo'
    name2 = 'Test Repo 2'
    # Mock the Octokit.search_repositories method to return a predefined value
    Octokit.stub :search_repositories, {
      'total_count' => 2,
      'items' => [
        {
          'name' => name,
          'full_name' => 'test/test-repo',
          'html_url' => 'https://github.com/test/test-repo',
          "owner": {
            'avatar_url' => 'https://github.com/test/test-repo'
          },
          'description' => 'Dummy description',
          'stargazers_count' => 1,
          'updated_at' => '2023-12-12T00:00:00',
          'watchers_count' => 1
        },
        {
          'name' => name2,
          'full_name' => 'test/test-repo2',
          'html_url' => 'https://github.com/test/test-repo2',
          "owner": {
            'avatar_url' => 'https://github.com/test/test-repo2'
          },
          'description' => 'Dummy description 2',
          'stargazers_count' => 1,
          'updated_at' => '2023-12-12T00:00:00',
          'watchers_count' => 1
        }
      ]
    } do
      query = 'example_query'
      result = @github_api.search_repositories(query)

      total_count = result['total_count']
      assert_equal 2, total_count

      first_item = result['items'].first
      assert_includes first_item['name'], name

      second_item = result['items'].second
      assert_includes second_item['name'], name2
    end
  end

  def test_search_repositories_with_empty_query
    name = 'Test Repo'
    # Mock the Octokit.search_repositories method to return a predefined value
    Octokit.stub :search_repositories, nil do
      query = 'example_query'
      result = @github_api.search_repositories(query)

      assert_nil result
    end
  end
end