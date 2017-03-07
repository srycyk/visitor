
require 'rails_helper'

RSpec.describe ImportBookmark, type: :model do
  include UserSupport
  include TagSupport
  include BookmarkSupport

  def bookmark_file_stub(data_path)
    double :bookmark_file, read: IO.read(data_path),
                           original_filename: data_path
  end

  def import_bookmark_create(path)
    bookmark_file = bookmark_file_stub path

    import_bookmark = ImportBookmark.new(bookmark_file: bookmark_file)

    import_bookmark.create

    import_bookmark
  end

  def import_bookmark_update(csv_text='', tag=nil)
    ImportBookmark.new(csv_text: csv_text,
                       tag_id: tag.to_param,
                       user: user).persistent!
  end

  def self.browsers
    { firefox: %r(http://api.rubyonrails.org/),
      chrome: %r(http://thesaurus-lexdump.rhcloud.com/),
    }
  end

  describe "create" do
    browsers.each do |browser, re|
      it "reads #{browser} bookmarks" do
        path = fixture_template % browser

        import_bookmark = import_bookmark_create path

        expect(import_bookmark.csv_text).to match re
      end
    end

    it "reads csv file" do
      path = fixture_root + 'bookmarks.csv'

      import_bookmark = import_bookmark_create path

      expect(import_bookmark.csv_text)
        .to match(%r(http://localhost:3000/import_bookmarks))
    end

    %w(empty html).each do |file_type|
      it "ignores invalid #{file_type} file" do
        path = fixture_template % file_type

        import_bookmark = import_bookmark_create path

        expect(import_bookmark.csv_text).to be_blank
      end
    end

    it "needs bookmark file" do
      import_bookmark = ImportBookmark.new(bookmark_file: nil)

      expect(import_bookmark.valid?).to be_falsey
    end

    it "resets itself" do
      import_bookmark = import_bookmark_create(fixture_root + 'bookmarks.csv')

      expect(import_bookmark.reset.bookmark_file).to be_nil
    end
  end

  describe "update" do
    let (:url) { "http://localhost:3000/tags/17/bookmarks" }

    let (:tag_name) { "level 1/name_tag" }

    it "reads csv" do
      csv_text = "#{url},#{tag_name}\r\n#{url}/nowhere/,#{tag_name}\r\n\r\n"

      import_bookmark = import_bookmark_update csv_text

      bookmarks = import_bookmark.update

      expect(bookmarks.compact.size).to eq 2
    end

    it "reads plain text as csv" do
      import_bookmark = import_bookmark_update "#{url}\r\n"

      bookmarks = import_bookmark.update

      expect(bookmarks.first.url).to eq url
    end

    it "puts bookmark into tag 'imported' if no tag specified" do
      import_bookmark = import_bookmark_update "#{url}\r\n"

      bookmarks = import_bookmark.update

      expect(bookmarks.first.tag.name).to eq 'imported'
    end

    it "puts bookmark into given tag name" do
      tag

      import_bookmark = import_bookmark_update "#{url},#{tag_name}\r\n"

      bookmarks = import_bookmark.update

      expect(bookmarks.first.tag.to_path).to eq tag_name
    end

    it "creates tags from given name only when they don't exist" do
      tag

      import_bookmark = import_bookmark_update "#{url},#{tag_name}\r\n"

      bookmarks = import_bookmark.update

      new_tag = bookmarks.first.tag

      expect(new_tag.name).to eq tag_name.split('/').last
      expect(new_tag.root).to eq tag.root
    end

    it "needs csv text" do
      expect(import_bookmark_update.valid?).to be_falsey
    end

    it "resets itself" do
      expect(import_bookmark_update('f1,f2').reset.csv_text).to be_blank
    end
  end
end
