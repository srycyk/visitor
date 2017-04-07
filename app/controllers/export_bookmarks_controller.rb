
# Writes out all of a User's Bookmarks as CSV, for later reloading
class ExportBookmarksController < TagTreeController
  def index
    csv_text = ExportBookmark.new.(bookmarks)

    send_data csv_text, type: 'text/csv', filename: "bookmarks.csv"
  end

  private

  def bookmarks
    current_user.bookmarks.order_by(:tag_id).eager_tags
  end
end

