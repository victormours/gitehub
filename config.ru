require 'rack'

require_relative 'github_client'

class App

  def render_issue(issue)
    "<li>
      <h2>#{issue["title"]}</h2>
      <p>opened by #{issue["username"]}</p>
    </li>"
  end

  def call(env)
    path = env["PATH_INFO"]
    path_elements = path.split("/")

    user_name = path_elements[1]
    repo_name = path_elements[2]

  	github_client = GithubClient.new

    issues = github_client.issues(user_name, repo_name)

    body = "
      <h1>Issues</h1>
      <ul>
         #{issues.map { |i| render_issue(i) }.join}
      </ul>
    "


    [200, { "content-type" => "text/html" }, [body]]

  end

end

run App.new
