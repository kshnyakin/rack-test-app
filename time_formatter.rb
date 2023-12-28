class TimeFormatter

  AVAILABLE_FORMATS = %w[year month day hour minute second].freeze
  TIME_FORMATS = { 
    "year"   => "%Y",
    "month"  => "%m",
    "day"    => "%d",
    "hour"   => "%H",
    "minute" => "%M",
    "second" => "%S"
  }.freeze

  attr_reader :incorrect_format_arr

  def initialize(params)
    @formats = params['format'].split(',')
    @correct_format_arr, @incorrect_format_arr = check_passed_format
  end

  def check_passed_format
    @formats.partition { |format| TIME_FORMATS[format] }
  end

  def valid?
    @incorrect_format_arr.empty?
  end

  def time
    formats = @correct_format_arr.map { |format| TIME_FORMATS[format]}
    Time.now.strftime(formats.join('-'))
  end
end
