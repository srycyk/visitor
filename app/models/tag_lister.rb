
class TagLister
  attr_accessor :relation

  attr_accessor :tag

  def initialize(user)
    self.relation = user.tags.ordered.eager_parents
  end

  def call(query: nil, tag_id: nil)
    self.relation = relation.search(query) if query.present?

    if tag_id.present?
      self.tag = Tag.find_by id: tag_id

      if tag and tag.owner? user
        self.relation = relation.where(tag_id: tag_id)
      end
    end

    relation
  end
end
