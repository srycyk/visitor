require 'rails_helper'

RSpec.feature "Tags", type: :feature do
  let (:root_tag) { create :tag }

  let (:tag) { create :tag, tag_id: root_tag.id }

  feature "new tag" do
    scenario "creates root" do
      visit new_tag_path

      fill_in "tag_name", with: "price_tag"

      click_button "Save"

      expect(page).to have_content(/Tag.+price_tag.+created/)
    end

    scenario "creates nested" do
      visit new_tag_path tag_id: tag

      fill_in "tag_name", with: "dog_tag"

      click_button "Save"

      expect(page).to have_content(/Tag.+dog_tag.+created/)
      expect(page).to have_content(tag.to_path)
    end

    scenario "validates" do
      visit new_tag_path

      fill_in "tag_name", with: ""

      click_button "Save"

      expect(page).to have_content(/error.+name.+blank/i)
    end
  end

  feature "existing tag" do
    scenario "changes name" do
      visit edit_tag_path tag

      fill_in "tag_name", with: "price_tag"

      click_button "Save"

      expect(page).to have_content(/Tag.+price_tag.+updated/)
    end

#save_and_open_page
#puts another_tag.debug
#puts tag.debug
#puts root_tag.debug
    scenario "changes parent tag" do
      another_tag = create :tag

      visit edit_tag_path tag

      select another_tag.to_s, from: "tag_tag_id"

      click_button "Save"

      expect(page).to have_content(/Tag.+#{tag}.+updated/)
      expect(page).to have_content(another_tag.to_path)
    end

    scenario "validates" do
      visit edit_tag_path tag

      fill_in "tag_name", with: ""

      click_button "Save"

      expect(page).to have_content(/error.+name.+blank/i)
    end

    scenario "invoked from index page" do
      root_tag

      visit tags_path

      click_link 'Edit'

      expect(page).to have_content(root_tag.to_s)
    end
  end

  feature "removing tag" do
    scenario "from delete link" do
      root_tag

      visit tags_path

      click_link 'Delete'

      expect(page).to have_content(/Tag.+#{root_tag}.+deleted/)
    end
  end

  feature "show tag" do
    scenario "invoked from index page" do
      root_tag

      visit tags_path

      click_link 'Show'

      expect(page).to have_content(/Show.+Tag.+#{root_tag.to_s}/)
    end
  end
end
