require 'rails_helper'

RSpec.feature "Tags", type: :feature do
  include UserSupport
  include TagSupport

  before { signin(user.email, user.password) }

  feature "index listing" do
    scenario "shows all" do
      tag

      visit tags_path

      expect(page).to have_content(/Name.+#{tag}/)
    end

    scenario "searching" do
      visit tags_path q: tag.tag.name

      expect(page).to have_content(/Name.+#{tag.tag}/)

      expect(page).not_to have_content(/Name.+#{tag}/)
    end
  end

  feature "new tag" do
    scenario "creates root" do
      visit new_tag_path

      fill_in "tag_name", with: "price_tag"

      click_button "Create Tag"

      expect(page).to have_content(/Tag.+price_tag.+created/)
    end

    scenario "creates nested" do
      visit new_tag_path tag_id: tag

      fill_in "tag_name", with: "dog_tag"

      click_button "Create Tag"

      expect(page).to have_content(/Tag.+dog_tag.+created/)
      expect(page).to have_content(tag.to_path)
    end

    scenario "validates" do
      visit new_tag_path

      fill_in "tag_name", with: ""

      click_button "Create Tag"

      expect(page).to have_content(/error.+name.+blank/i)
    end
  end

  feature "existing tag" do
    scenario "changes name" do
      visit edit_tag_path tag

      fill_in "tag_name", with: "price_tag"

      click_button "Update Tag"

      expect(page).to have_content(/Tag.+price_tag.+updated/)
    end

    scenario "changes parent tag" do
      another_tag = create :tag, user: user

      visit edit_tag_path tag

      select another_tag.to_s, from: "tag_tag_id"

      click_button "Update Tag"

      expect(page).to have_content(/Tag.+#{tag}.+updated/)
      expect(page).to have_content(another_tag.to_path)
    end

    scenario "validates" do
      visit edit_tag_path tag

      fill_in "tag_name", with: ""

      click_button "Update Tag"

      expect(page).to have_content(/error.+name.+blank/i)
    end

    scenario "invoked from index page" do
      root_tag

      visit tags_path

      find("a[title^='Edit']").click

      expect(page).to have_content(root_tag.to_s)
    end
  end

  feature "removing tag" do
    scenario "from delete link" do
      root_tag

      visit tags_path

      find("a[title^='Delete']").click

      expect(page).to have_content(/Tag.+#{root_tag}.+deleted/)
    end
  end

  feature "show tag" do
    scenario "invoked from index page" do
      root_tag

      visit tags_path

      find("a[title^='Show']").click

      expect(page).to have_content(/Show.+Tag.+#{root_tag.to_s}/)
    end
  end
end
