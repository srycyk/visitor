
# A Bookmark's data record
class Bookmark < ApplicationRecord
  include TagOwnerEnforcement

  belongs_to :tag, counter_cache: true

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

  private

  class << self
    def retain(url, tag, title, description)
      return unless url.present?

      find_or_create_by(url: url, tag: tag) do |bookmark|
        bookmark.title = title if title.present?

        bookmark.description = description if description.present?
      end
    end

    private

    def search_fields
      Concerns::SearchFields.new(:url, :title, :description, table: table_name)
    end
  end
end
