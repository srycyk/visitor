
class Bookmark < ApplicationRecord
  belongs_to :tag, counter_cache: true

  #scope :ordered, -> { order :url, :tag_id }
  scope :order_by, -> name { order name }

  scope :date_order, -> { order updated_at: :desc }

  scope :tag_name_order, -> { joins(:tag).order "tags.name", :url }

  scope :eager_tags, -> (depth=6) { includes Tag.tree_includes(depth, :tag) }

  scope :search, -> query { where search_fields.(query) }

  validates :url, presence: true

  delegate :in_path?, :to_path, to: :tag

  def to_s
    url
  end

  def self.search_fields
    Concerns::SearchFields.new(:url, :title, :description, table: table_name)
  end
end
