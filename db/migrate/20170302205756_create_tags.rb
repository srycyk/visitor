class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :title
      t.references :tag
      t.integer :tags_count
      t.integer :bookmarks_count

      t.timestamps
    end
  end
end
