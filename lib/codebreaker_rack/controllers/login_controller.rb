module CodebreakerRack
  module Controllers
    class LoginController < Controller
      def getAction
        error = request.session['error']
        request.session.delete('error')

        CodebreakerRack::View.new('login.form', {
          error: error
        })
      end

      def postAction
        user = request.params['nickname']
        
        if user.to_s.empty?
          request.session['error'] = 'Username is required.'
        else 
          request.session['user'] = user
        end

        redirect_to('/')
      end
    end
  end
end
