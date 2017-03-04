
module ImportBookmarksHelper
  def upload_help
    'Either upload a file from a browser export, or a CSV file from here'
  end

  def text_help
    "You can, instead, put in plain text containing a list of URL's"
  end

  def tag_help
    "All sites in 'CSV text' will be loaded under this tag"
  end
end
