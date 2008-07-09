class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.text :body
      t.text :formatted_body
      t.text :formatted_preview
      t.integer :language_id
      t.string :theme, :default => "clean"
      t.integer :taggings_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :snippets
  end
end
