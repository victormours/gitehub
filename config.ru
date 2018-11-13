require 'rack'
require 'erb'

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

    render('templates/issues_index.html.erb', binding)
  end

  def new_issue(user_name, repo_name)
    render('templates/new_issue.html.erb', binding)
  end

  def create_issue(request)
    title = request.params["title"]
    github_client = GithubClient.new
    github_client.create_issue(title)
  end

  def render(template_name, context)
    template = File.read(template_name)

    renderer = ERB.new(template)
    renderer.result(context)
  end

end

run App.new
