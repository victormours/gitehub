require 'rack'
require 'erb'

require_relative 'gitehub_controller'

class App

  def initialize
    @controller = GitehubController.new(self)
  end

  def call(env)
    request = Rack::Request.new(env)
    path = request.path
    path_elts = path.split("/")

    if path_elts[3..4] == ["issues", "new"]
      @controller.new_issue(path_elts[1], path_elts[2])
    elsif path_elts[3] == "create_issue"
      @controller.create_issue(request)
    elsif path_elts[3] && path_elts[3][/^\d+$/] && path_elts[4] == 'create_dependency'
      @controller.create_dependency(request, path_elts[3])
    elsif path_elts[3] && path_elts[3][/^\d+$/]
      @controller.issue_show(path_elts[1], path_elts[2], path_elts[3])
    else
      @controller.issues_index(path_elts[1], path_elts[2])
    end
  end

  def render(template_name, context)
    template = File.read(template_name)
    renderer = ERB.new(template)
    body = renderer.result(context)
    [200, { "content-type" => "text/html" }, [body]]
  end

  def redirect(location)
    [302, { "location" => location }, []]
  end

end

run App.new
