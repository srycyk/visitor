
module Concerns
  module LoadTagTree
    extend ActiveSupport::Concern

    included do
      before_action :load_tag_tree
    end

    private

    def load_tag_tree
      if user_signed_in?
        @tag_tree = current_user.tags.tree.all
      end
    end
  end
end
