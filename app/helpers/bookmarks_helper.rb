
module BookmarksHelper
  def open_tabs_js
     %{$('.bookmark').each(function() {
                             window.open($(this).attr('href'), '_blank')
                           }) ; return false }
  end

  def open_tabs_title
    'Bring up all listed sites in separate tabs'
  end
end
