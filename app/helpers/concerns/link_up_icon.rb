
module Concerns
  class LinkUpIcon < LinkUp
    attr_accessor :icon

    def initialize(type=nil, **options)
      super

      set_icon
    end

    def link_to(view_context, path, **opts)
      link(*args, **options) { view_context.icon(icon) }
    end

    def set_icon(icon=nil)
      self.icon = icon || options.delete(:icon) || type_to_icon || type.to_s

      self
    end

    private

    def html_class
      ''
    end

    def type_to_icon
      { new: 'add',
        edit: 'pencil',
        delete: 'delete',
        show: 'zoom',
        list: 'list',

        back: 'arrow_left',

        more: 'arrow_down',
      }[type]
    end
  end
end

