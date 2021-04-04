require 'rack'
require_relative 'app/controllers/base_controller'
require_relative 'app/controllers/dogs_controller'

# The base application class that sets up the runtime of the application
class Application

  # Initialize the application class with container injected.
  # @param container - The IOC container used to store all kinds of dependencies
  def initialize(container)
    @container = container

    register_controllers
  end

  # Parse all the controllers defined and inject them into the IOC container.
  def register_controllers
    controllers = BaseController.descendants
    route_regex = /^(?<route>[A-Z][a-z]+)Controller/
    routes = controllers.map { |c| [c.to_s, c] }
                        .map { |c, k| [route_regex.match(c)[:route].downcase, k] }
                        .to_h
    routes['dogs'].new
    puts routes
  end

  # Setup the dependencies injection for the application.
  def setup_container
    raise "Example"
  end

  def call(env)
    request = Rack::Request.new(env)
    serve_request(request)
  end

  def serve_request(request)
    Router.new(request).route!
  end
end

puts BaseController.descendants
Application.new(nil)