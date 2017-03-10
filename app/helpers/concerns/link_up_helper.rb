
module Concerns
  module LinkUpHelper
    def link_up(type, path=nil, opts={}, extra_opts={})
      LinkUp.new(type, opts).link_to self, path, extra_opts
    end

    def link_up_icon(type, path=nil, opts={}, extra_opts={})
      LinkUpIcon.new(type, opts).link_to self, path, extra_opts
    end

    def link_up_btn(type, path=nil, opts={}, extra_opts={})
      LinkUpBtn.new(type, opts).set_size('md').link_to self, path, extra_opts
    end
  end
end
