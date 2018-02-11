require 'codebreaker'

module CodebreakerRack
  module Controllers
    class HintController < Controller
      include GameMixin

      def getAction
        return nil unless game = get_game

        game.hint!
      end

      private

      def get_game
        return nil unless request.session['game']

        deserialize_game(Codebreaker::Game.new)
      end
    end
  end
end
