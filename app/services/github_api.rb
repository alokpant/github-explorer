# frozen_string_literal: true

# Simple GithubApi Service to fetch repositories
class GithubApi
  def initialize
  end

  def search_repositories(query)
    Octokit.search_repositories(query)
  end
end
