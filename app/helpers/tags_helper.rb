
module TagsHelper
  def select_option_tags
    Tag.ordered.map {|tag| [ tag.to_path, tag.to_param ] }
      .sort
  end

  def site_count(tag)
    pluralize tag.bookmarks_count, 'site'
  end

  def tag_title(tag, prefix: 'for ', suffix: ' ')
    tag ? prefix << tag.to_path << suffix : ''
  end

  def in_path?(candidate_tag, receiver, yes: 'in', no: '')
    #reciever = Tag.find_by id: receiver if String === receiver or Integer === receiver

    receiver.try(:in_path?, candidate_tag) ? yes : no
  end
end
