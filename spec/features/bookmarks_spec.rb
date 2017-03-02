require 'rails_helper'

RSpec.feature "Bookmarks", type: :feature do
  URL = 'http://localhost:3000/index.htm'

  let (:root_tag) { create :tag }

  let (:tag) { create :tag, tag_id: root_tag.id }

  let (:bookmark) { create :bookmark, tag_id: tag.id }

  feature "new bookmark" do
    scenario "created" do
      visit new_tag_bookmark_path tag

      fill_in "bookmark_url", with: URL

      click_button "Save"

      expect(page).to have_content(/Bookmark.+#{URL}.+created/)
    end

    scenario "validated" do
      visit new_tag_bookmark_path tag

      fill_in "bookmark_url", with: ''

      click_button "Save"

      expect(page).to have_content(/error.+url.+blank/i)
    end
  end

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

      expect(find_field('bookmark_url').value).to eq bookmark.url

      expect(page).to have_content(/Edit.+Bookmark.+#{bookmark.tag}/)
    end
  end

  feature "removing bookmark" do
    scenario "from delete link" do
      bookmark

      visit tag_bookmarks_path tag

      click_link 'Delete'

      expect(page).to have_content(/Bookmark.+#{bookmark}.+deleted/)
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
end
