module CodebreakerRack
  module Controllers
    module SessionMixin
      def reset_session
        reset_game
        reset_attempts
      end

      def reset_game
        request.session.delete('game')
      end

      def reset_attempts
        request.session.delete('attempts')
      end
    end
  end
end
