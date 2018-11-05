require 'rack'

class App

  def call(env)

    [200, {}, ["Hello world!"]]
  end

end

run App.new
