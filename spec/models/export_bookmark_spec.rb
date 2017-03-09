
require 'rails_helper'

RSpec.describe ExportBookmark, type: :model do
  include UserSupport
  include TagSupport
  include BookmarkSupport

  let (:bookmarks) { [ bookmark, create(:bookmark, tag_id: tag.id) ] }

  it "renders csv text" do
    export_bookmark = ExportBookmark.new

    line_match = /#{bookmark.url},#{bookmark.to_path}/

    expect(export_bookmark.(bookmarks)).to match line_match
  end

  it "handles empty list" do
    export_bookmark = ExportBookmark.new

    expect(export_bookmark.([])).to be_blank
  end
end
