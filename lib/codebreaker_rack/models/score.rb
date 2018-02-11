module CodebreakerRack
  module Models
    class Score < Model
      attr_accessor :name, :points

      def initialize
        @pk = 'name'
      end
    end
  end
end
