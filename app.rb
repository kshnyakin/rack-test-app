require 'pry'
require_relative 'services/request_handler'

class App
  def call(env)
    Services::RequestHandler.new(env).call
  end
end
