
module ApplicationHelper
  include Concerns::HtmlSettings

  def search_form_controller?(controller)
    controllers = %w(tags bookmarks import_bookmarks export_bookmarks)

    controllers.include? params['controller']
  end

  def icon(name)
    " <span class='glyphicon glyphicon-#{name}' aria-hidden='true'></span> "
      .html_safe
  end

  def active(page)
    # Workround to avoid error with Devise
    return '' unless  search_form_controller? params['controller']

    current_page?(page) ? 'active' : ''
  end

  def show_date(date)
    date.to_date.to_s
  end

  def show_time(time)
    time.strftime "%c"
  end

  def title(name)
    { sign_in: 'For registered, or returning, users',
      sign_up: 'For new users',
      new_tag_top: 'Create a top level tag',
      new_tag: 'Create a tag',
      list_tags: 'List all tags',
      list_bookmarks: 'List all bookmarked sites',
      upload_bookmarks: 'Upload bookmarks from CSV, Firefox or Chrome',
      download_bookmarks: 'Download all bookmarks as CSV File',
    }[name.to_sym] or name.to_s.humanize
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
