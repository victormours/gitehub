require_relative 'github_client'

class GitehubController

  def initialize(app)
    @app = app
    @dependencies = []
  end

  def issues_index(user_name, repo_name)
    github_client = GithubClient.new
    issues = github_client.issues(user_name, repo_name)
    @app.render('templates/issues_index.html.erb', binding)
  end

  def new_issue(user_name, repo_name)
    @app.render('templates/new_issue.html.erb', binding)
  end

  def create_issue(request)
    title = request.params["title"]
    github_client = GithubClient.new
    github_client.create_issue(title)
    @app.redirect("/victormours/gitehub")
  end

  def issue_show(user_name, repo_name, number)
    github_client = GithubClient.new
    issue = github_client.find_issue(user_name, repo_name, number)
    issue_list = github_client.issues(user_name, repo_name)
    @app.render('templates/issue_show.html.erb', binding)
  end

  def create_dependency(request, child_issue_number)
    parent_issue_number = request.params["issue_number"]
    @dependencies << {
      "parent_issue_id" => parent_issue_number,
      "child_issue_id" => child_issue_number
    }
    @app.redirect("/victormours/gitehub/#{child_issue_number}")
  end

end
