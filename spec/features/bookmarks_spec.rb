require 'rails_helper'

RSpec.feature "Bookmarks", type: :feature do
  include UserSupport
  include TagSupport
  include BookmarkSupport

  URL = 'http://localhost:3000/index.htm'

  before { signin(user.email, user.password) }

  feature "new bookmark" do
    scenario "created" do
      visit new_tag_bookmark_path tag

      fill_in "bookmark_url", with: URL

      click_button "Create Bookmark"

      expect(page).to have_content(/Bookmark.+#{URL}.+created/)
    end

    scenario "validated" do
      visit new_tag_bookmark_path tag

      fill_in "bookmark_url", with: ''

      click_button "Create Bookmark"

      expect(page).to have_content(/error.+url.+blank/i)
    end
  end

  feature "existing bookmark" do
    scenario "changes url" do
      visit edit_tag_bookmark_path tag, bookmark

      fill_in "bookmark_url", with: URL + '/path'

      click_button "Update Bookmark"

      expect(page).to have_content(/Bookmark.+#{URL + '/path'}.+updated/)
    end

    scenario "changes tag" do
      another_tag = create :tag, user_id: user.id

      visit edit_tag_bookmark_path tag, bookmark

      select another_tag.to_s, from: "bookmark_tag_id"

      click_button "Update Bookmark"

      expect(page).to have_content(/Bookmark.+#{bookmark}.+updated/)
      expect(page).to have_content(another_tag.to_path)
    end

    scenario "changes title" do
      visit edit_tag_bookmark_path tag, bookmark

      fill_in "bookmark_title", with: 'x yy zzz'

      click_button "Update Bookmark"

      expect(page).to have_content(/Bookmark.+#{bookmark}.+updated/)
      expect(page).to have_content('x yy zzz')
    end

    scenario "validates blank url" do
      visit edit_tag_bookmark_path tag, bookmark

      fill_in "bookmark_url", with: ""

      click_button "Update Bookmark"

      expect(page).to have_content(/error.+url.+blank/i)
    end

    scenario "invoked from index page" do
      bookmark

      visit tag_bookmarks_path tag

      find("a[title^='Edit']").click

      expect(find_field('bookmark_url').value).to eq bookmark.url

      expect(page).to have_content(/Edit.+Bookmark.+#{bookmark.tag}/)
    end
  end

  feature "removing bookmark" do
    scenario "from delete link" do
      bookmark

      visit tag_bookmarks_path tag

      find("a[title^='Delete']").click

      expect(page).to have_content(/Bookmark.+#{bookmark}.+deleted/)
    end
  end

  feature "show bookmark" do
    scenario "invoked from index page" do
      bookmark

      visit tag_bookmarks_path tag

      find("a[title^='Show']").click

      expect(page).to have_content(bookmark.to_s)
    end
  end
end
