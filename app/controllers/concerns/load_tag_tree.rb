
module Concerns
  module LoadTagTree
    extend ActiveSupport::Concern

    included do
      before_action :load_tag_tree
    end

    private

    def load_tag_tree
      @tag_tree = Tag.tree.all
    end
  end
end
