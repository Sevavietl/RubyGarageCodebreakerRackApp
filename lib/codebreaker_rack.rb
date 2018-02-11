require "codebreaker_rack/version"

require_relative 'codebreaker_rack/storage/csv_storage'

require_relative 'codebreaker_rack/middleware/auth'
require_relative 'codebreaker_rack/middleware/router'

require_relative 'codebreaker_rack/models/model'
require_relative 'codebreaker_rack/models/score'

require_relative 'codebreaker_rack/controllers/game_mixin'
require_relative 'codebreaker_rack/controllers/session_mixin'
require_relative 'codebreaker_rack/controllers/controller'
require_relative 'codebreaker_rack/controllers/login_controller'
require_relative 'codebreaker_rack/controllers/logout_controller'
require_relative 'codebreaker_rack/controllers/game_controller'
require_relative 'codebreaker_rack/controllers/hint_controller'
require_relative 'codebreaker_rack/controllers/statistic_controller'

require_relative 'codebreaker_rack/view'

module CodebreakerRack
  class CodebreakerRackApp
    def self.call(env)
      request = Rack::Request.new(env)

      response = env['action'][request]

      if response.is_a? Rack::Response
        response
      else
        Rack::Response.new(response.to_s)
      end
    end
  end
end
