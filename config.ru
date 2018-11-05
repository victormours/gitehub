require 'rack'

require_relative 'github_client'

class App

  def call(env)

  	github_client = GithubClient.new

    titles = github_client.titles

    body = "
      <h1>Issues</h1>
      <ul>
         #{titles.map do |word|
           "<li><h2>#{word}</h2></li>"
         end.join}
      </ul>
    "


    [200, { "content-type" => "text/html" }, [body]]

  end

end

run App.new
