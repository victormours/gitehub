require "faraday"
require "json"

response = Faraday.get 'https://api.github.com/repos/victormours/gitehub/issues'

issues = JSON.parse(response.body)

sorted_issues = issues.sort_by do |issue|
  issue["number"]
end

sorted_issues.each do |issue|
  p issue["title"]
end
