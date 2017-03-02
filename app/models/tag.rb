
class Tag < ApplicationRecord
  belongs_to :tag, counter_cache: true, required: false

  has_many :tags, dependent: :destroy

  has_many :bookmarks, dependent: :destroy

  #belongs_to :parent, required: false, class_name: 'Tag'
  #has_many :children, class_name: 'Tag'

  scope :ordered, -> { order :name }

  scope :eager_tree, -> (depth=6) { includes tree_includes(depth) }

  scope :roots, -> { where tag_id: nil }

  scope :tree, -> { roots.eager_tree.ordered }

  scope :eager_parents, -> (depth=6) { includes tree_includes(depth, :tag) }

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

=begin
  def expunge
    tags.each {|tag| tag.expunge }

    destroy
  end
=end

  def expand
    @expanded ||= expansion
  end

  def expansion(current=self)
    if current
      expansion(current.tag) + [ current ]
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

  def to_tree(level=0, indent: '  ', eol: "\r\n")
    tags.inject indent * level + to_s(eol) do |acc, tag|
      acc << tag.to_tree(level + 1, indent: indent, eol: eol)
    end
  end

  def info
    "#{self}(#{bookmarks_count || 0})"
  end

  def debug
    "#{self} #{inspect} #{to_path}"
  end

  def heading
    "#{bookmarks_count} - #{title.presence || name}"
  end

  class << self
    def mkpath(*path_names)
      parent = nil

      path_names.flatten.map do |name|
        tag = find_or_create_by name: name, tag_id: parent

        parent = tag.id

        tag
      end
    end

    def obliterate!
      roots.delete_all
    end

    def tree_includes(depth, assoc=:tags)
      { assoc => depth <= 2 ? assoc : tree_includes(depth - 1, assoc) }
    end
  end
end

