
require 'rails_helper'

require 'tag_name_factory'

RSpec.describe ExportBookmark, type: :model do
  let (:root_tag) { create :tag }

  let (:tag) { create :tag, tag_id: root_tag.id }

  let (:bookmark) { create :bookmark, tag_id: tag.id }

  let (:bookmarks) { [ bookmark, create(:bookmark, tag_id: tag.id) ] }

  it "renders csv text" do
    export_bookmark = ExportBookmark.new

    line_match = /#{bookmark.url},#{bookmark.to_path}/

    expect(export_bookmark.(bookmarks)).to match line_match
  end

  it "handles empty list" do
    export_bookmark = ExportBookmark.new

    line_match = /#{bookmark.url},#{bookmark.to_path}/

    expect(export_bookmark.([])).to be_blank
  end
end
