
module Concerns
  module FormFieldGroupHelper
    ROWS = 4

    def remote(atts={})
      atts.merge remote: remote?
    end
    def remote?
      false
    end

    def form_control(extra_classes='')
      { class: "form-control #{extra_classes}" }
    end

    # Changes a form's size and field alignmen, 3 are preset below
    def form_field_settings(atts=nil)
      if atts
        @form_field_settings = FormFieldSettings.new(**atts)
      elsif @form_field_settings
        @form_field_settings
      else
        @form_field_settings = FormFieldSettings.new
      end
    end

    def set_large_form!
      form_field_settings field_size: 'lg', label_cols: 3, field_cols: 8
    end

    def set_medium_form!
      form_field_settings field_size: 'md', label_cols: 3, field_cols: 7
    end

    def set_small_form!
      @form_field_settings = nil

      form_field_settings
    end

    # Renders an HTML form field, with Bootstrap styling
    # The various types are handled in the methods below
    def field_group(name, locals={}, options={}, &block)
      locals = locals.merge name: name

      args = options.merge layout: 'field_group', locals: locals

      render args, &block
    end

    def text_field_group(form, name, locals={})
      field_group name, locals do
        form.text_field name, form_control.merge(locals)
      end
    end

    def text_area_field_group(form, name, locals={})
      field_group name, {field_size: 'md'}.merge(locals) do
        form.text_area name, form_control.merge(rows: ROWS).merge(locals)
      end
    end

    def datetime_field_group(form, name, locals={})
      field_group name do
        content_tag :div, class: 'field-group form-inline row' do
          form.datetime_select name, locals, form_control
        end
      end
    end

    def checkbox_field_group(form, name, locals={})
      field_group name do
        form.check_box name, locals
      end
    end

    def file_field_group(form, name, locals={})
      field_group name, locals do
        form.file_field name, form_control.merge(locals)
      end
    end

    def select_field_group(form, name, select_options,
                           blank: false, cols: nil, locals: {})
      locals[:field_cols] = cols if cols

      field_group name, locals do
        form.select name, select_options, {include_blank: blank}, form_control
      end
    end

    # Standard submit button for the form's preset size
    def submit_class(size=nil)
      size = form_field_settings.field_size unless size

      "btn btn-primary btn-#{size}"
    end

=begin
    def checkbox_field_group(form, name)
      field_group name, title: false, suffix: name.to_s.humanize do
        form.check_box name
      end
    end
=end

=begin
    def partial_field_group(form, name, partial_name=name, locals={})
      locals, partial_name = partial_name, name if Hash === partial_name

      field_group name, locals.merge(f: form), partial: partial_name
    end
=end
  end
end
