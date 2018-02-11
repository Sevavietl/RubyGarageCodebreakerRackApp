module CodebreakerRack
  module Controllers
    class LogoutController < Controller
      include SessionMixin

      def getAction
        reset_user
        reset_session

        redirect_to('/login')
      end

      private

      def reset_user
        request.session.delete('user')
      end
    end
  end
end
