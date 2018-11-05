require "faraday"
require "json"

class GithubClient

	def titles
		github_url = 'https://api.github.com/repos/victormours/gitehub/issues'
		response = Faraday.get(github_url, {:direction => 'asc'})
		issues = JSON.parse(response.body)
		
		titles = []
		issues.each do |issue|
			titles += [issue["title"]]
		end

		titles
	end

end
