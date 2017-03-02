
require 'csv'

class BookmarkCsvLoader < Struct.new(:list, :tag_path)
  FIELD_NAMES = %i(url tag title description)

  DEFAULT_TAG = 'imported'

  def call
    Bookmark.transaction do
      self.list = CSV.parse(list) if String === list

      list.map do |line|
        atts = case line
               when String, Array
                 array_to_atts line
               else
                 line
               end

        load_from_atts atts
      end
    end
  end

  def array_to_atts(field_values)
    field_values = CSV.parse_line(field_values) if String === field_values

    FIELD_NAMES.zip(field_values).to_h
  end

  def load_from_atts(atts)
    tag = Tag.mkpath((tag_path || atts[:tag] || DEFAULT_TAG).split '/').last

    url, title, description = atts.values_at :url, :title, :description

    return unless url.present?
=begin
#puts atts
#tag = tag_path || atts[:tag] || 'imported'
#puts "#{url} #{tag} #{title} #{description}"
return
=end
    Bookmark.find_or_create_by(url: url, tag: tag) do |bookmark|
      bookmark.title = title if title.present?

      bookmark.description = description if description.present?
    end
  end
end
