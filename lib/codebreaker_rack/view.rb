require 'erb'
require 'ostruct'

module CodebreakerRack
  class View
    def initialize(view, vars = {}, layout = nil)
      @user = vars[:user]
      @error = vars[:error]

      @view = ERB.new(view_template(view))
      @binding = OpenStruct.new(vars).instance_eval { binding }
      @layout = ERB.new(view_template(layout || 'layout.main'))
    end

    def to_s
      content = @view.result(@binding)
      @layout.result(OpenStruct.new({content: content, user: @user, error: @error})
        .instance_eval { binding })
    end

    private

    def view_template(view)
      File.open(view_path(view), 'rb') { |f| f.read }
    end

    def view_path(view)
      File.join(view.split('.').unshift(__dir__, 'views')).concat('.rhtml')
    end
  end
end
