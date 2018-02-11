require 'csv'

module CodebreakerRack
  module Storage
    class CSVStorage
      def initialize(folder = "#{ __dir__ }/data")
        @folder = folder.chomp('/')
      end
      
      def add(table, record)
        CSV.open(filename(table), 'a') { |csv| csv << record }

        record
      end

      def update(table, record)
        filename = filename(table)
        records = CSV.read(filename)
        
        CSV.open(filename, 'w') do |csv|
          records.each{ |row| csv.puts row[0] == record[0] ? record : row }
        end
        
        record
      end

      def find(table, id)
        CSV.read(filename(table)).find { |row| row[0] == id }
      end

      def all(table)
        CSV.read(filename(table))
      end

      private
      
      attr_reader :folder

      def filename(table)
        "#{ folder }/#{ table }.csv"
      end
    end
  end
end
