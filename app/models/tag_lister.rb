
# Fetches a list of Tags for a user
# And, optionally, tags under a parent Tag, and/or a partial string search
class TagLister
  attr_accessor :user, :tag

  def initialize(user)
    self.user = user
  end

  def call(query: nil, tag_id: nil)
    relation = user.tags.ordered.eager_parents

    relation = relation.search(query) if query.present?

    if tag_id.present?
      self.tag = Tag.find_by id: tag_id

      if tag and tag.owner? user
        relation = relation.where(tag_id: tag_id)
      end
    end

    relation
  end
end
