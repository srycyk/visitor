
module ApplicationHelper
  include Concerns::HtmlSettings

  def indent(level)
    if level > 1
      #(" &nbsp; " * level + icon('menu-right') + ' ').html_safe
      (" &nbsp; " * level + '&#155; ').html_safe
    else
      ' '
    end
  end

  def icon(name)
    "<span class='glyphicon glyphicon-#{name}' aria-hidden='true'></span>"
      .html_safe
  end

  def show_date(date)
    date = date.to_date

    #date.strftime ""
    date.to_s
  end
  def show_time(time)
    time.to_s
  end
end
