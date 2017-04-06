
require 'csv'

# For adding new Bookmark's from uploaded data files
class ImportBookmarksController < TagTreeController
  before_action { @import_bookmark = ImportBookmark.new import_bookmark_params }

  def index
  end

  # Reads uploaded data file in CSV, or in a Firefox/Chrome export
  # If it's in the export HTML format, it's converted to CSV
  # This CSV data is copied into the HTML form field for end-user to review
  def create
    @import_bookmark.create if @import_bookmark.valid?

    if (csv_text = @import_bookmark.csv_text).present?
      flash.now[:notice] = "Up to #{csv_text.count "\n"} CSV records found"
    end

    render :index
  end

  # Is passed the CSV data (in the HTML form field), and adds Bookmark records
  def update
    @import_bookmark.user = current_user

    if @import_bookmark.persistent!.valid?
      bookmarks = @import_bookmark.update

      @import_bookmark.reset

      flash.now[:notice] = "Up to #{bookmarks.size} bookmarks created"
    end

    render :index
  end

  private

  def import_bookmark_params
    params.fetch(:import_bookmark, {})
          .permit(:bookmark_file, :csv_text, :tag_id)
  end
end

