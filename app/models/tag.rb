
class Tag < ApplicationRecord
  include UserForTag

  include TagOwnerEnforcement

  belongs_to :tag, counter_cache: true, required: false

  has_many :tags, dependent: :destroy

  has_many :bookmarks, dependent: :destroy

  before_validation :clean_name

  before_create { self.title = name.humanize if title.blank? }

  scope :ordered, -> { order :name }

  scope :eager_tree, -> (depth=6) { includes tree_includes(depth) }

  scope :roots, -> { where tag_id: nil }

  scope :tree, -> { roots.eager_tree.ordered }

  scope :eager_parents, -> (depth=6) { includes tree_includes(depth, :tag) }

  scope :search, -> query { where search_fields.(query) }

  validates :name, presence: true

  def to_s(suffix='')
    "#{name}#{suffix}"
  end

  def to_path(delim='/')
    expand.map(&:to_s) * delim
  end

  def in_path?(candidate_tag)
    expand.include? candidate_tag
  end

  # Had problems with self-referential dependent: :destroy
  def expunge
    tags.each {|tag| tag.expunge }

    destroy
  end

  def expand
    @expanded ||= expansion
  end

  def expansion(current=self)
    if current
      expansion(current.tag) << current
    else
      []
    end
  end

  def root
    expand.first
  end
  def branch
    expand[0..-2]
  end

  def heading
    title.presence or name.capitalize
  end

  def info
    "#{heading}, #{tags_count || 0} below, #{bookmarks_count || 0} bookmarked"
  end

  def to_tree(level=0, indent: '  ', eol: "\r\n")
    tags.inject indent * level + to_s(eol) do |acc, tag|
      acc << tag.to_tree(level + 1, indent: indent, eol: eol)
    end
  end

  def children?
    (tags_count || 0) > 0
  end

  private

  def clean_name
    self.name = name.tr '/', '-' if name.index '/'
  end

  class << self
    def create_tree(tag_or_user, *names)
      if name = names.pop
        create_tree(tag_or_user, *names)
          .tags.find_or_create_by(name: name.to_s)
      else
        tag_or_user
      end
    end

    def tree_includes(depth, assoc=:tags)
      { assoc => depth <= 2 ? assoc : tree_includes(depth - 1, assoc) }
    end

    private

    def search_fields
      Concerns::SearchFields.new(:name, :title, table: table_name)
    end
  end
end

