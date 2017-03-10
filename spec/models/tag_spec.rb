
require 'rails_helper'

RSpec.describe Tag, type: :model do
  include UserSupport
  include TagSupport

  it "needs name" do
    tag.name = ''

    expect(tag.valid?).to be_falsey
  end

  it "subsitutes '/' in name" do
    tag.name = 'a/b'

    tag.valid?

    expect(tag.name).to eq 'a-b'
  end

  it "expands path" do
    expect(tag.to_path).to match /level 1.+level 2.+level 3/
  end

  it "finds root tag" do
    expect(tag.root.name).to eq 'level 1'
  end

  it "finds branch" do
    expect(tag.branch * '/').to eq 'level 1/level 2'
  end

  it "deletes self" do
    expect(tag.expunge).to be_destroyed
  end

  it "deletes children" do
    tag.root.expunge

    expect{ tag.reload }.to raise_error ActiveRecord::RecordNotFound
  end

  it "detects if candidate in path" do
    expect(tag.in_path? tag.root).to be_truthy
    expect(tag.in_path? tag.tag).to be_truthy
    expect(tag.in_path? tag).to be_truthy
  end

  it "detects if candidate NOT in path" do
    expect(tag.in_path? create(:tag)).to be_falsey
  end

  it "increases counter cache" do
    expect(tag.tag.tags_count).to eq 1
  end

  it "makes a new path given a list of tag names" do
    tag

    extra_tag = Tag.create_tree(user, 'level 1', 'extra_tag')

    expect(extra_tag.tag).to eq tag.root
  end

  it 'propigates user in children' do
    expect(tag.user).to eq user
  end

  it 'disallows change to a parent tag owned by someone else' do
    anothers_tag = create :tag

    tag.tag = anothers_tag

    tag.save

    expect(tag.tag).to eq branch_tag
  end
end
