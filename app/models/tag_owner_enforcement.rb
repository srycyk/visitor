
module TagOwnerEnforcement
  extend ActiveSupport::Concern

  included do
    before_validation :ensure_tag_ownership
  end

  private

  def ensure_tag_ownership
    if tag_id_changed?
      if tag and tag_id_was and tag.user != Tag.find(tag_id_was).user
        self.tag_id = tag_id_was
      end
    end
  end
end
