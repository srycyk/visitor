
class ImportBookmark
  include ActiveModel::Model

  include ActiveModel::Validations::Callbacks

  attr_accessor :bookmark_file, :csv_text, :tag_id

  attr_accessor :user

  attr_accessor :persistent

  validates :bookmark_file, presence: true, unless: :persisted?

  validates :csv_text, presence: true, if: :persisted?

  # Converts uploaded file to CSV, if necessary
  def create
    uploaded_data = bookmark_file.read
    uploaded_file = bookmark_file.original_filename

    if uploaded_file =~ /.+\.html?$/
      lines = BookmarkLinkParser.new(uploaded_data).()
    end

    self.csv_text = lines ? to_csv_text(lines) : uploaded_data
  end

  # Adds Bookmark records from CSV data
  def update
    BookmarkCsvLoader.new(csv_text, tag_path, user).()
  end

  # For PUT method on update
  def persisted?
    persistent
  end
  def to_param
    persisted? ? '0' : nil
  end
  def persistent!(dtruth=true)
    self.persistent = dtruth

    self
  end

  def reset
    self.csv_text = ''
    self.bookmark_file = nil

    self
  end

  private

  def tag_path
    if tag_id.present?
      Tag.find(tag_id).to_path
    end
  end

  def to_csv_text(lines)
    CSV.generate row_sep: "\r\n" do |csv|
      lines.each {|line| csv << line }
    end
  end
end
