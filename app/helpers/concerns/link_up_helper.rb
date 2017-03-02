
module Concerns
  module LinkUpHelper
    def link_up(type, path=nil, opts={}, extra_opts={})
      LinkUp.new(type, opts).link_to self, path, extra_opts
    end

    def switch_text(dtruth, yes='Yes', no='No')
      dtruth ? yes : no
    end

    def switch_icon(dtruth)
      icon dtruth ? 'lightbulb' : 'lightbulb_off'
    end

    private

    def icon_path(name)
      File.join 'icons', "#{name}.png"
    end
  end
end
