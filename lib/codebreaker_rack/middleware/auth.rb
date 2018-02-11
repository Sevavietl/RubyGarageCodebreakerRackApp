module CodebreakerRack
  module Middleware
    class Auth
      def initialize(app)
        @app = app       
      end                
    
      def call(env)
        request = Rack::Request.new(env)
        
        if !request.session['user'].to_s.empty?
          @app.call(env)
        elsif request.path == '/login'
          @app.call(env)
        else
          Rack::Response.new do |response|
            response.redirect('/login')
          end
        end
      end
    end
  end
end
