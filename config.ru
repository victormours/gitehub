require 'rack'

require_relative 'github_client'

class App

  def call(env)

  	github_client = GithubClient.new

    [200, {}, github_client.titles]
  
  end

end

run App.new
