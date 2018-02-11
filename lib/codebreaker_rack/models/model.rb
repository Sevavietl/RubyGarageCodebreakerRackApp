module CodebreakerRack
  module Models
    class Model
      @storage = CodebreakerRack::Storage::CSVStorage.new

      class << self
        attr_accessor :storage

        def attr_accessor *vars
          @attributes ||= []
          @attributes.concat vars
          super(*vars)
        end

        def attributes
          @attributes
        end

        def find(id)
          if record = Model.storage.find(table, id)
            hydrate(self.new, record)
          else
            nil
          end
        end
        
        def all
          Model.storage.all(table).inject([]) do |carry, record|
            carry << hydrate(self.new, record)
            carry
          end
        end

        def table
          "#{name.split('::').last.downcase}s"
        end

        def hydrate(model, record)
          attributes.each_with_index do |attribute, index|
            model.public_send("#{attribute}=", record[index])
          end

          model
        end
      end

      def initialize
        @pk = 'id'
      end

      def save
        if self.class.find(public_send(@pk))
          Model.storage.update(self.class.table, to_ary)
        else
          Model.storage.add(self.class.table, to_ary)
        end
      end

      def to_ary
        attributes.inject([]) do |arr, attribute|
          arr.push(public_send(attribute))
          arr
        end
      end

      def attributes
        self.class.attributes
      end
    end
  end
end
