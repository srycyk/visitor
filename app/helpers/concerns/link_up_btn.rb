
# For rendering links as Bootstrap button
module Concerns
  class LinkUpBtn < LinkUp
    mattr_accessor :btn_size

    attr_accessor :btn_type, :btn_size

    def initialize(type=nil, **options)
      super

      set_type

      set_size
    end

    def set_type(type=nil)
      self.btn_type = type || btn_type || options.delete(:btn_type) ||
                                          type_to_btn_type || 'default'

      self
    end

    def set_size(size=nil)
      self.btn_size = size || btn_size || options.delete(:btn_size) ||
                                          self.class.btn_size || 'md'

      self
    end

    private

    def html_class
      "btn btn-#{btn_size} btn-#{btn_type}"
    end

    def type_to_btn_type
      { new: 'primary',
        edit: 'warning',
        delete: 'danger',
        show: 'info',
        list: 'info',

        back: 'success',

        js: 'danger',

        more: 'default',
      }[type]
    end
  end
end

