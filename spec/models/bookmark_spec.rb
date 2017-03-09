
require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  include UserSupport
  include TagSupport
  include BookmarkSupport

  it "shows url when rendered to string" do
    expect(bookmark.to_s).to eq bookmark.url
  end

  it "needs url" do
    bookmark.url = ''

    expect(bookmark.valid?).to be_falsey
  end

  it "needs tag" do
    bookmark.tag_id = nil

    expect(bookmark.valid?).to be_falsey
  end

  it "reverts to original if new tag owned by someone else" do
    bookmark.tag = create :tag

    bookmark.valid?

    expect(bookmark.tag).to eq tag
  end

  it "delegates to_path to corresponding tag" do
    expect(bookmark.to_path).to eq tag.to_path
  end

  it "increases counter cache" do
    expect(bookmark.tag.bookmarks_count).to eq 1
  end
end
