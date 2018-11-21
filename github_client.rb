require "faraday"
require "json"

class GithubClient

	def issues(user_name, repo_name)
		github_url = "https://api.github.com/repos/#{user_name}/#{repo_name}/issues"
		response = Faraday.get(github_url, {:direction => 'asc'})
		issues = JSON.parse(response.body)

		issues.map do |issue|
      {
        "title" => issue["title"],
        "username" => issue["user"]["login"],
				"number" => issue["number"]
      }
		end
	end

  def create_issue(title)
    github_url = "https://api.github.com/repos/victormours/gitehub/issues"

    connection = Faraday.new do |conn|
      conn.basic_auth('victormours', ENV['GITEHUB_API_KEY'])
      conn.adapter(Faraday.default_adapter)
    end

    connection.post(github_url, { title: title }.to_json)
  end

	def find_issue(user_name, repo_name, number)
		github_url = "https://api.github.com/repos/#{user_name}/#{repo_name}/issues/#{number}"
		response = Faraday.get(github_url)
		issue = JSON.parse(response.body)
	end

end
