require 'rack'

require_relative 'github_client'

class App

  def call(env)
    path = env["PATH_INFO"]
    path_elements = path.split("/")

    user_name = path_elements[1]
    repo_name = path_elements[2]

    if path_elements[3..4] == ["issues", "new"]
      body = new_issue
    else
      body = issues_index(user_name, repo_name)
    end

    [200, { "content-type" => "text/html" }, [body]]
  end

  def issues_index(user_name, repo_name)
    github_client = GithubClient.new

    issues = github_client.issues(user_name, repo_name)

    "
      <h1>Issues</h1>
      <ul>
         #{issues.map { |i| render_issue(i) }.join}
      </ul>
      <a href='/#{user_name}/#{repo_name}/issues/new'>New Issue</a>
    "
  end

  def new_issue
    "This is the page for a new issue"
  end

  def render_issue(issue)
    "<li>
      <h2>#{issue["title"]}</h2>
      <p>opened by #{issue["username"]}</p>
    </li>"
  end

end

run App.new
