module CodebreakerRack
  module Controllers
    class StatisticController < Controller
      def getAction
        scores = CodebreakerRack::Models::Score.all

        CodebreakerRack::View.new('statistic.index', {
          user: request.session['user'],
          scores: scores
        })
      end
    end
  end
end
