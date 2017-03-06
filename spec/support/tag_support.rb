
=begin
require 'tag_name_factory'

module TagSupport
  extend ActiveSupport::Concern

  include TagNameFactory

  FIXTURE_ROOT = "#{Rails.root}/spec/fixtures/"

  FIXTURE_TEMPLATE = "#{FIXTURE_ROOT}bookmarks-%s.html"

  included do
    let(:tag) { nested_tag 3 }
  end

  def x
  end
end
=end
