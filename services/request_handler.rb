module Services
  class RequestHandler

    TIME_ROUTE = 'time'.freeze
    METHOD_GET = 'GET'.freeze
    AVAILABLE_FORMATS = %w[year month day hour minute second].freeze
    PARAMETER_KEY = 'format'.freeze
    TIME_METHODS_HASH = {
      "year" => "year",
      "month" => "month",
      "day" => "day",
      "hour" => "hour",
      "minute" => "min",
      "second" => "sec"
    }.freeze

    def initialize(env)
      @env = env
    end

    def call
      return [404, {}, ['Bad request']] unless check_route_and_type
      handle_parameters
    end

    private

    def check_route_and_type
      route_ok = @env["PATH_INFO"].gsub(/\//, '').downcase == TIME_ROUTE
      type_ok = @env["REQUEST_METHOD"] == METHOD_GET
      route_ok && type_ok
    end

    def handle_parameters
      return [400, {}, ['No parameters passed']] if @env["QUERY_STRING"].empty?
      check_format_parameters
    end

    def check_format_parameters
      parameter_key, parameter_value = @env["QUERY_STRING"].split('=')
      return [400, {}, ['Incorrect parameter']] unless parameter_key.downcase == PARAMETER_KEY
      
      passed_formats_arr = CGI.unescape(parameter_value).split(',').map(&:downcase)
      delta_formats = passed_formats_arr - AVAILABLE_FORMATS
      return [400, {}, ["Unknown time format #{delta_formats}"]] unless delta_formats.empty?

      response = create_response_string(passed_formats_arr)
      [200, {'Content-type' => 'text-plain'}, [response]]
    end

    def create_response_string(formats)
      time = Time.now
      result = formats.map{|format| time.send(TIME_METHODS_HASH[format])}.join('-')
    end
  end
end
