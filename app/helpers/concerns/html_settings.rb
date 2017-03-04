
module Concerns
  module HtmlSettings
    def table_classes
      'table table-hover table-condensed table-bordered'
    end

    def index_classes
      'table table-hover table-striped table-bordered'
    end

    def form_atts(classes='')
      default_form_atts classes
    end

    def default_form_atts(classes='', form_class="form-horizontal")
      { html: { role: 'form', class: "#{form_class} #{classes}" } }
    end

    def inline_form_atts(classes='')
      default_form_atts classes, "form-inline"
    end

=begin
    def search_form_atts(classes='')
      { method: :get, class: "form-inline #{classes}" }
    end
=end

    def offset_row(offset_cols=nil)
      offset_cols ||= form_field_settings.label_cols

      locals = { klass: "col-sm-offset-#{offset_cols}" }

      render(layout: 'row', locals: locals) { yield }
    end

    def two_col_class
      'col-sm-6'
    end

=begin
    def sub_heading(text=' &nbsp; '.html_safe, classes='')
      content_tag :h3, class: "text-center text-muted #{classes}" do
        content_tag :span, content_tag(:em, text)
      end
    end

    def back_button(path_back: nil, text: 'Back', size: 'md')
      if path_back
        link_to 'Back', path_back, class: "btn btn-default btn-#{size}"
      end
    end
=end
  end
end
