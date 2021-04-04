require 'rack'
require 'rioc'
require_relative 'app/controllers/base_controller'
require_relative 'app/controllers/dogs_controller'

# The base application class that sets up the runtime of the application
class Application

  # Initialize the application class with container injected.
  def initialize
    @container = Rioc::RiocContainer.new

    configure_route_map
    register_controllers
    @container.register(:foo) { |c| "Test" }
    @container.build_container
  end

  # Register all controllers into the IOC container.
  def register_controllers
    @route_map.each do |route, controller|
      @container.register(route, lazy: true) { |c| controller.injector(c) }
    end
  end

  # Parse all the controllers defined and figure out a routing map
  def configure_route_map
    controllers = BaseController.descendants
    route_regex = /^(?<route>[A-Z][a-z]+)Controller/
    @route_map = controllers.map { |c| [c.to_s, c] }
                        .map { |c, k| [route_regex.match(c)[:route].downcase, k] }
                        .to_h
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

  def do_work
    dogs = @route_map['dogs'].injector(@container)
    puts dogs
    dogs.bark
  end
end

puts BaseController.descendants
app = Application.new
app.do_work