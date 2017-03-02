
require 'csv'

class ExportBookmark
  CSV_FIELDS = %i(url to_path title description)

  attr_accessor :text

  def initialize
    self.text = StringIO.new
  end

  def call(bookmarks)
    CSV(text, row_sep: "\r\n") do |csv|
      sort(bookmarks).each {|bookmark| csv << to_list(bookmark) }
    end

    text.string
  end

  private

  def to_list(bookmark)
    CSV_FIELDS.map {|name| bookmark.send name }
  end

  def sort(bookmarks)
    bookmarks.sort_by &:to_path
  end
end

