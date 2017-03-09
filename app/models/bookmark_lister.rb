
class BookmarkLister
  attr_accessor :relation

  def initialize(tag_or_user)
    self.relation = tag_or_user.bookmarks.limit(200)
  end

  def call(query: nil, by: nil)
    self.relation = relation.search(query) if query.present?

    self.relation = in_order(by.to_sym) if by.present?

    self.relation = relation.eager_tags
  end

  private

  def in_order(by)
    case by
    when *%i(url title description)
      relation.order_by(by)
    when :date
      relation.date_order
    when :tag
      relation.tag_name_order
    else
      relation
    end
  end
end
