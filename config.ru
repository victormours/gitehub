require 'rack'

require_relative 'github_client'

class App

  def call(env)
    request = Rack::Request.new(env)
    path = request.path
    path_elements = path.split("/")

    user_name = path_elements[1]
    repo_name = path_elements[2]

    if path_elements[3..4] == ["issues", "new"]
      body = new_issue(user_name, repo_name)
      [200, { "content-type" => "text/html" }, [body]]
    elsif path_elements[3] == "create_issue"
      create_issue(request)
      [302, { "location" => "/victormours/gitehub" }, []]
    else
      body = issues_index(user_name, repo_name)
      [200, { "content-type" => "text/html" }, [body]]
    end
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

  def new_issue(user_name, repo_name)
    "
      This is the page for a new issue
      <br />
      <form
        action='/#{user_name}/#{repo_name}/create_issue'
        method='post'
      >
        <input name='title'></input>
        <br />
        <button>Create</button>
      </form>
    "
  end

  def create_issue(request)
    title = request.params["title"]
    github_client = GithubClient.new
    github_client.create_issue(title)
  end

  def render_issue(issue)
    "<li>
      <h2>#{issue["title"]}</h2>
      <p>opened by #{issue["username"]}</p>
    </li>"
  end

end

run App.new
