
require 'active_support/concern'

module BookmarkSupport
  extend ActiveSupport::Concern

  #FIXTURE_ROOT = "#{Rails.root}/spec/fixtures/"

  #FIXTURE_TEMPLATE = "#{FIXTURE_ROOT}bookmarks-%s.html"

  included do
    let (:bookmark) { create :bookmark, tag_id: tag.to_param }
  end

  def fixture_root
    "#{Rails.root}/spec/fixtures/"
  end

  def fixture_template
    "#{fixture_root}bookmarks-%s.html"
  end
end

