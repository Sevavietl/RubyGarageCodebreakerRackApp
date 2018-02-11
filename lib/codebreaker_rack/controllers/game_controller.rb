require 'codebreaker'

module CodebreakerRack
  module Controllers
    class GameController < Controller
      include GameMixin
      include SessionMixin
      
      def getAction
        game = get_game
        
        payload = {
          user: request.session['user'],
          attempt_number: game.send(:to_a)[0] + 1,
          number_of_attempts: Codebreaker::Game::NUMBER_OF_ATTEMPTS,
          attempts: request.session['attempts']
        }

        if payload[:error] = request.session['error']
          request.session.delete(:error)
        end

        CodebreakerRack::View.new('game.form', payload)
      end
      
      def postAction
        game = get_game
        
        unless game.in_progress?
          return Rack::Response.new('Forbidden', 403)
        end

        code = request.params['code']
        
        begin
          game.guess(code)
        rescue Codebreaker::Exceptions::InvalidGuessFormat
          request.session['error'] = 'Invalid guess format'
          return redirect_to('/')
        end
        
        add_attempt({code: code, matching: game.marks})
           
        if game.attempts_available?
          serialize_game(game)
          redirect_to('/')
        else
          reset_session
          score = game.won? ? 1 : 0
          save_score(score)

          CodebreakerRack::View.new('game.end', {
            user: request.session['user'],
            result: %i(lost won)[score]
          })
        end
      end

      def add_attempt(attempt)
        unless request.session['attempts']
          request.session['attempts'] = []
        end

        request.session['attempts'].push(attempt)
      end

      def save_score(points)
        score = CodebreakerRack::Models::Score.find(request.session['user'])

        unless score
          score = CodebreakerRack::Models::Score.new
          score.name = request.session['user']
          score.points = 0
        end

        score.points = score.points.to_i + points
        score.save
      end
    end
  end
end
