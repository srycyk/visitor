
class ExportBookmarksController < TagTreeController
  def index
    bookmarks = Bookmark.order_by(:tag_id)

    csv_text = ExportBookmark.new.(bookmarks)

    send_data csv_text, type: 'text/csv', file_name: "bookmarks.csv"
  end

  private

end

