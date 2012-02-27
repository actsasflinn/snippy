class AddSyntaxToLanguages < ActiveRecord::Migration
  def change
    add_column :languages, :syntax, :string
  end
end
