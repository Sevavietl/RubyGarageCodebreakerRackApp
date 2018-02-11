require 'codebreaker'

module CodebreakerRack
  module Controllers
    module GameMixin
      private

      def get_game
        game = Codebreaker::Game.new
        
        unless request.session['game']
          game.start
          serialize_game(game)
          return game
        end

        deserialize_game(game)
      end

      def serialize_game(game)
        request.session['game'] = %i(secret_code hints attempts_left status).inject({}) do |hash, key|
          hash[key] = game.instance_variable_get("@#{key}".to_sym)
          hash
        end
      end

      def deserialize_game(game)
        %i(secret_code hints attempts_left status).each do |key|
          game.instance_variable_set("@#{key}".to_sym, request.session['game'][key])
        end

        game.send(:matcher).secret_code = request.session['game'][:secret_code]
        game
      end
    end
  end
end
