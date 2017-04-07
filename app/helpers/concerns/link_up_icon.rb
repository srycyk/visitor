
# For rendering links as a Bootstrap icon
module Concerns
  class LinkUpIcon < LinkUp
    attr_accessor :icon, :path

    def initialize(type=nil, **options)
      super

      set_icon
    end

    def link_to(view_context, path, **opts)
      self.path = path

      link(view_context, path, **opts) { view_context.icon(icon) }
    end

    def set_icon(icon=nil)
      self.icon = icon || options.delete(:icon) || type_to_icon || type.to_s

      self
    end

    private

    def title
      "#{derive_text(path).capitalize} - #{type_to_title}"
    end

    def html_class
      'text-muted'
    end

    def type_to_icon
      { new: 'plus-sign',
        edit: 'edit',
        delete: 'trash',
        show: 'info-sign',
        list: 'th-list',

        back: 'arrow-left',

        more: 'arrow-down',
      }[type]
    end
  end
end

