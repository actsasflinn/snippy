class AddSnookAttributes < ActiveRecord::Migration
  def self.up
    add_column :snippets, :author, :string
    add_column :snippets, :email, :string
    add_column :snippets, :url, :string
    add_column :snippets, :spam_status, :string
  end

  def self.down
    remove_column :snippets, :spam_status
  end
end
