require 'pry'
require_relative 'time_formatter'

class App
  def call(env)
    request = Rack::Request.new(env)
    return rack_response(400, 'Incorrect request parameters') if request.params['format'].nil?

    time_formatter = TimeFormatter.new(request.params)
    if time_formatter.valid?
      rack_response(200, time_formatter.time)
    else
      rack_response(400, "Unknown time format#{time_formatter.incorrect_format_arr}\n")
    end
  end

  private

  def rack_response(status, body)
    Rack::Response.new(body, status).finish
  end

end
