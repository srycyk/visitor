
require 'csv'

class ImportBookmarksController < TagTreeController
  before_action { @import_bookmark = ImportBookmark.new import_bookmark_params }

  def index
  end

  def create
    @import_bookmark.create if @import_bookmark.valid?

    if (csv_text = @import_bookmark.csv_text).present?
      flash.now[:notice] = "Up to #{csv_text.count "\n"} CSV records found"
    end

    render :index
  end

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

