require "faraday"
require "json"

class GithubClient

	def issues(user_name, repo_name)
		github_url = "https://api.github.com/repos/#{user_name}/#{repo_name}/issues"
		response = Faraday.get(github_url, {:direction => 'asc'})
		issues = JSON.parse(response.body)
    puts issues

		issues.map do |issue|
      {
        "title" => issue["title"],
        "username" => issue["user"]["login"]
      }
		end
	end

end
