# frozen_string_literal: true

# Repositories controller to allow users to search for Github Repositories
class RepositoriesController < ApplicationController
  def index
  end

  def search
    search_term = params[:search_term]

    if search_term.nil? || search_term.strip == ''
      format_error('Search keyword cannot be empty')
      return
    end

    @results = GithubApi.new.search_repositories(search_term)
  rescue Octokit::Error => e
    format_error(e.message)
  end

  private

  def format_error(message)
    @error = "Error: #{message}"
  end
end
