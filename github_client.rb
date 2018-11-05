require "faraday"
require "json"

response = Faraday.get 'https://api.github.com/repos/victormours/gitehub/issues', {:direction => 'asc'}

issues = JSON.parse(response.body)

issues.each do |issue|
  p issue["title"]
end
