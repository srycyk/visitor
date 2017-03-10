
module ApplicationHelper
  include Concerns::HtmlSettings

  def search_form_controller?(controller)
    controllers = %w(tags bookmarks import_bookmarks export_bookmarks)

    controllers.include? params['controller']
  end

  def icon(name)
    " &nbsp; <span class='glyphicon glyphicon-#{name}' aria-hidden='true'></span> "
      .html_safe
  end

  def active(page)
    current_page?(page) ? 'active' : ''
  end

  def show_date(date)
    date = date.to_date

    date.to_s
  end

  def show_time(time)
    time.strftime "%c"
  end

=begin
  def indent(level)
    if level > 1
      (" &nbsp; " * level + '&#155; ').html_safe
    else
      ' '
    end
  end

  def switch_text(dtruth, yes='Yes', no='No')
    dtruth ? yes : no
  end

  def switch_icon(dtruth)
    icon dtruth ? 'tick' : 'cross'
  end
=end
end
