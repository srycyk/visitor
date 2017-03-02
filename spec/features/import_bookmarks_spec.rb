require 'rails_helper'

RSpec.feature "ImportBookmarks", type: :feature do
  PATH_ROOT = "#{Rails.root}/spec/fixtures/"

  PATH_TEMPLATE = "#{PATH_ROOT}bookmarks-%s.html"

  let (:root_tag) { create :tag }

  let (:tag) { create :tag, tag_id: root_tag.id }

  feature "upload bookmark html files" do
    scenario "from firefox" do
      visit import_bookmarks_path

      file = PATH_TEMPLATE % 'firefox'

      attach_file "import_bookmark_bookmark_file", file

      click_button "Upload"

      csv_text = find_field('import_bookmark_csv_text').value

      expect(csv_text).to match(%r(http://api.rubyonrails.org/))
    end

    scenario "from chrome" do
      visit import_bookmarks_path

      file = PATH_TEMPLATE % 'chrome'

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

      file = PATH_ROOT + 'bookmarks.csv'

      attach_file "import_bookmark_bookmark_file", file

      click_button "Upload"

      csv_text = find_field('import_bookmark_csv_text').value

      expect(csv_text).to match(%r(http://localhost:3000/import_bookmarks))
    end

    scenario "empty file" do
      visit import_bookmarks_path

      file = PATH_TEMPLATE % 'empty'

      attach_file "import_bookmark_bookmark_file", file

      click_button "Upload"

      csv_text = find_field('import_bookmark_csv_text').value

      expect(csv_text).to be_blank
    end

    scenario "any old html file" do
      visit import_bookmarks_path

      file = PATH_TEMPLATE % 'html'

      attach_file "import_bookmark_bookmark_file", file

      click_button "Upload"

      csv_text = find_field('import_bookmark_csv_text').value

      expect(csv_text).to be_blank
    end
  end

=begin
save_and_open_page
      expect(csv_text).to match(%r(http://api.rubyonrails.org/))

  feature "existing bookmark" do
    scenario "changes url" do
      visit edit_tag_bookmark_path tag, bookmark

      fill_in "bookmark_url", with: URL + '/path'

      click_button "Save"

      expect(page).to have_content(/Bookmark.+#{URL + '/path'}.+updated/)
    end

    scenario "changes tag" do
      another_tag = create :tag

      visit edit_tag_bookmark_path tag, bookmark

      fill_in "bookmark_title", with: 'xxxx'
      select another_tag.to_s, from: "bookmark_tag_id"

      click_button "Save"

      expect(page).to have_content(/Bookmark.+#{bookmark}.+updated/)
      expect(page).to have_content(another_tag.to_path)
    end

    scenario "validates" do
      visit edit_tag_bookmark_path tag, bookmark

      fill_in "bookmark_url", with: ""

      click_button "Save"

      expect(page).to have_content(/error.+url.+blank/i)
    end

    scenario "invoked from index page" do
      bookmark

      visit tag_bookmarks_path tag

      click_link 'Edit'

      expect(page).to have_content(bookmark.to_s)
    end
  end

  feature "remove bookmark" do
    scenario "from delete link" do
      bookmark

      visit tag_bookmarks_path tag

      click_link 'Destroy'

      expect(page).to have_content(/Bookmark.+#{bookmark}.+destroyed/)
    end
  end

  feature "show bookmark" do
    scenario "invoked from index page" do
      bookmark

      visit tag_bookmarks_path tag

      click_link 'Show'

      expect(page).to have_content(bookmark.to_s)
    end
  end
=end
end
