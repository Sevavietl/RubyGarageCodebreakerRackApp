module CodebreakerRack
  module Middleware
    class Router
      def initialize(app, &block)
        @app = app
        
        @routes = Hash.new { |h, k| h[k] = {} }

        instance_eval(&block) if block_given?
      end                
    
      def call(env)
        request = Rack::Request.new(env)

        action = routes[request.path]

        if action.empty?
          return Rack::Response.new('Not Found.', 404)
        end

        action = action[request.request_method]

        unless action
          return Rack::Response.new('Method Not Allowed.', 405)
        end

        env['action'] = action

        @app.call(env)
      end

      private

      attr_reader :routes

      def get(route, action)
        add_route(route, 'GET', action)
      end

      def post(route, action)
        add_route(route, 'POST', action)
      end
      
      def put(route, action)
        add_route(route, 'PUT', action)
      end

      def patch(route, action)
        add_route(route, 'PATCH', action)
      end

      def delete(route, action)
        add_route(route, 'DELETE', action)
      end

      def add_route(route, method, action)
        controller, action = parse_action(action)

        @routes[route] ||= {}
        @routes[route][method] = ->(request) { controller.new(request).public_send(action) }
      end

      def parse_action(action)
        controller, action = action.split('@')
        controller = Object::const_get(controller)

        return [controller, action]
      end
    end
  end
end
