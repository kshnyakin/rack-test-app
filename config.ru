require_relative 'middleware/runtime'
require_relative 'middleware/logger'
require_relative 'app'

ROUTES = {
  '/time' => App.new
}

use Runtime
use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
use Rack::Reloader
use Rack::ContentType, "text/plain"
run Rack::URLMap.new(ROUTES)
