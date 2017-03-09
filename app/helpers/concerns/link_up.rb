
module Concerns
  class LinkUp
    attr_accessor :type, :options

    attr_accessor :control_opts

    #attr_accessor :text

    def initialize(type=nil, **options)
      self.type = type.to_sym

      self.options = options

      set_control_opts
    end

    def link_to(view_context, path, **opts)
      link(view_context, path, **options)
    end

    def link(view_context, path, **opts)
      path = type unless path

      link_contents = block_given? ? yield : get_text(path)

      view_context.link_to link_contents, path, all_opts(opts)
    end

    def get_text(path=nil)
      options.delete(:text) or type_to_text or
                               derive_text(path).strip.capitalize
    end

    private

    def derive_text(path)
      type_prefix + ' ' + text_suffix(path)
    end

    def type_prefix
      type_has_no_prefix? ? '' : type.to_s.humanize
    end

    def text_suffix(path)
      type_has_suffix? ? guess_suffix(path) : ''
    end

    def guess_suffix(path)
      case path
      when Symbol, String
        path.to_s
      when Array
        case last = path.last
        when Symbol, String
          last.to_s
        else
          #last.class.name.downcase
          ''
        end
      else
        ''
      end.tr('_', ' ')
    end

    def all_opts(**opts)
      control_opts.merge title_options.merge html_atts.merge(opts)
    end

    def title_options
      unless options.has_key? :title
        options[:title] = title
      end

      options
    end

    def title
      type_to_title or type.to_s.titlecase
    end

    def html_atts
      options[:class] ||= ''

      options[:class] += ' ' + html_class

      options
    end

    def html_class
      #"text-muted"
      "btn btn-xs btn-link "
    end

    def set_control_opts
      self.control_opts = {}

      set_control_opt :remote

      set_control_opt :data

      set_method

      set_confirm
    end

    def set_method
      if method = type_to_method
        control_opts[:method] = method
      end

      set_control_opt :method
    end

    def set_control_opt(name)
      control_opts[name] = options.delete name if options.has_key? name
    end

    def set_confirm
      if confirm?
        message = String === options[:confirm] && options[:confirm] 

        control_opts[:data] = (control_opts[:data] || {}).merge confirm message

        options.delete :confirm
      end
    end

    def set_data(atts)
      control_opts[:data] ||= {}

      control_opts[:data].merge! atts
    end

    def set_confirm
      if confirm?
        message = String === options[:confirm] ? options[:confirm] : nil

        set_data confirm message

        options.delete :confirm
      end
    end

    def confirm?
      if options.has_key? :confirm
        options[:confirm]
      elsif control_opts.has_key? :method
        options[:method].to_s !~ /get/i
      else
        false
      end
    end

    def confirm(message)
      message = 'Are you sure?' if message.blank?

      { confirm: message }
    end

    def type_to_text
      { more: 'Show more',
      }[type]
    end

    def type_to_title
      { new: 'Add a new record',
        edit: 'Amend this record',
        delete: 'Remove this record',
        show: 'Display full record details',

        list: 'Display a table of records',
        items: 'Display a table of records',

        more: 'Click to see further details',

        back: 'Return to listing',

        import: 'Upload Bookmarks',
        export: 'Download Bookmarks',

        js: 'Perform operation',
      }[type]
    end

    def type_to_method
      { delete: :delete,
      }[type]
    end

    def type_has_suffix?
      %i(new list items).include? type
    end

    def type_has_no_prefix?
      %i(items js).include? type
    end
  end
end

