
class ExportBookmarksController < TagTreeController
  def index
    bookmarks = current_user.bookmarks.order_by(:tag_id).eager_tags

    csv_text = ExportBookmark.new.(bookmarks)

    send_data csv_text, type: 'text/csv', file_name: "bookmarks.csv"
  end

  private

end

