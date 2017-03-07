
require 'active_support/concern'

module TagSupport
  extend ActiveSupport::Concern

  included do
    let (:root_tag) { Tag.create name: 'level 1', user_id: user.to_param }

    let (:branch_tag) { Tag.create name: 'level 2', tag_id: root_tag.id }

    let(:tag) { Tag.create name: 'level 3', tag_id: branch_tag.id }
  end
end

