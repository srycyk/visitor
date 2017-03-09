
module TagsHelper
  def select_option_tags
    current_user.tags.eager_parents
      .map {|tag| [ tag.to_path, tag.to_param ] }
      .sort
  end

  def site_count(tag, text='bookmarked site')
    pluralize tag.bookmarks_count, text
  end

  def tag_title(tag, prefix: 'for ', suffix: ' ')
    tag ? prefix << tag.to_path << suffix : ''
  end

  def in_path?(candidate_tag, receiver, yes: 'in', no: '')
    receiver.try(:in_path?, candidate_tag) ? yes : no
  end
end
