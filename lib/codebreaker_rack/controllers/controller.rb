module CodebreakerRack
  module Controllers
    class Controller
      def initialize(request)
        @request = request
      end
      
      private

      attr_reader :request

      def redirect_to(path)
        Rack::Response.new do |response|
          response.redirect(path)
        end
      end
    end
  end
end
