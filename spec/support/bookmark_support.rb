
require 'active_support/concern'

module BookmarkSupport
  extend ActiveSupport::Concern

  included do
    let (:bookmark) { create :bookmark, tag_id: tag.to_param }
  end

  def fixture_root
    "#{Rails.root}/spec/fixtures/"
  end

  def fixture_template
    "#{fixture_root}bookmarks-%s.html"
  end

  def sample_url
    "http://localhost:3000/tags/#{rand 99_999}/bookmarks"
  end
end

