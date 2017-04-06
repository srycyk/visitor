
require 'csv'

# Adds new Bookmark records, given as input, the CSV data (created here),
# or, otherwise, a list (of a list) of the fields, in constant FIELD_NAMES
class BookmarkCsvLoader < Struct.new(:list, :tag_path, :user)
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
    tags = (tag_path || atts[:tag] || DEFAULT_TAG).split('/')

    tag = Tag.create_tree(user, *tags)

    url, title, description = atts.values_at :url, :title, :description

    Bookmark.retain(url, tag, title, description)
  end
end
