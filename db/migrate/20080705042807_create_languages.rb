class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string :name
      t.string :slug
      t.integer :snippets_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :languages
  end
end
