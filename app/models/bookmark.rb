
class Bookmark < ApplicationRecord
  belongs_to :tag, counter_cache: true

  attr_accessor :user

  #scope :ordered, -> { order :url, :tag_id }
  scope :order_by, -> name { order name }

  scope :date_order, -> { order updated_at: :desc }

  scope :tag_name_order, -> { joins(:tag).order "tags.name", :url }

  scope :eager_tags, -> (depth=6) { includes Tag.tree_includes(depth, :tag) }

  scope :search, -> query { where search_fields.(query) }

  before_validation :ensure_tag_ownership

  validates :url, presence: true

  delegate :in_path?, :to_path, to: :tag

  def to_s
    url
  end

  private

  def ensure_tag_ownership
    if tag_id_changed?
      #unless tag.owner? user
      #  self.tag_id = tag_id_was
      #end
    end
  end

  class << self
    def search_fields
      Concerns::SearchFields.new(:url, :title, :description, table: table_name)
    end
  end
end
