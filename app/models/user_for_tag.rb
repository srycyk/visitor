
# Links a User to a Tag, included in Tag class
module UserForTag
  extend ActiveSupport::Concern

  included do
    belongs_to :user

    before_validation { self.user = tag.user if tag and not user }

    validates :user_id, presence: true

    validates :name, uniqueness: { scope: %i(tag_id user_id) }
  end

  class_methods do
    def rm!(user)
      transaction do
        user.tags.roots.each {|tag| tag.expunge }
      end
    end
  end

  def owner?(candidate_user)
    candidate_user and to_param == candidate_user.to_param
  end
end

