require 'rails_helper'

RSpec.feature "ImportBookmarks", type: :feature do
  include UserSupport
  include TagSupport
  include BookmarkSupport

  before { signin(user.email, user.password) }

  feature "upload bookmark html files" do
    scenario "from firefox" do
      visit import_bookmarks_path

      file = fixture_template % 'firefox'

      attach_file "import_bookmark_bookmark_file", file

      click_button "Upload"

      csv_text = find_field('import_bookmark_csv_text').value

      expect(csv_text).to match(%r(http://api.rubyonrails.org/))
    end

    scenario "from chrome" do
      visit import_bookmarks_path

      file = fixture_template % 'chrome'

      attach_file "import_bookmark_bookmark_file", file

      click_button "Upload"

      csv_text = find_field('import_bookmark_csv_text').value

      expect(csv_text).to match(%r(http://thesaurus-lexdump.rhcloud.com/))
    end

    scenario "no file" do
      visit import_bookmarks_path

      click_button "Upload"

      expect(page).to have_content(/error.+Bookmark.+file.+blank/)
    end

    scenario "csv file" do
      visit import_bookmarks_path

      file = fixture_root + 'bookmarks.csv'

      attach_file "import_bookmark_bookmark_file", file

      click_button "Upload"

      csv_text = find_field('import_bookmark_csv_text').value

      expect(csv_text).to match(%r(http://localhost:3000/import_bookmarks))
    end

    scenario "empty file" do
      visit import_bookmarks_path

      file = fixture_template % 'empty'

      attach_file "import_bookmark_bookmark_file", file

      click_button "Upload"

      csv_text = find_field('import_bookmark_csv_text').value

      expect(csv_text).to be_blank
    end

    scenario "any old html file" do
      visit import_bookmarks_path

      file = fixture_template % 'html'

      attach_file "import_bookmark_bookmark_file", file

      click_button "Upload"

      csv_text = find_field('import_bookmark_csv_text').value

      expect(csv_text).to be_blank
    end
  end

  feature "reading bookmark CSV data" do
    let (:url) { sample_url }

    def bookmarks_tag(url)
      Bookmark.find_by(url: url).tag
    end

    scenario "enter CSV data which includes tag" do
      csv_text = "#{url},#{tag.to_path}"

      visit import_bookmarks_path

      fill_in "import_bookmark_csv_text", with: csv_text

      click_button "Import CSV Text"

      expect(page).to have_content(/Up to.+bookmark.+created/)

      expect(bookmarks_tag(url)).to eq tag
    end

    scenario "enter CSV data with overriding tag" do
      csv_text = "#{url},#{tag.to_path}"

      another_tag = create :tag, user: user

      visit import_bookmarks_path

      fill_in "import_bookmark_csv_text", with: csv_text

      select another_tag.to_s, from: "import_bookmark_tag_id"

      click_button "Import CSV Text"

      expect(page).to have_content(/Up to.+bookmark.+created/)

      expect(bookmarks_tag(url)).to eq another_tag
    end

    scenario "enter CSV data with no tag" do
      visit import_bookmarks_path

      fill_in "import_bookmark_csv_text", with: url

      click_button "Import CSV Text"

      expect(page).to have_content(/Up to.+bookmark.+created/)

      expect(bookmarks_tag(url).name).to eq 'imported'
    end
  end
end
