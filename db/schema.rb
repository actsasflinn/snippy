# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080705043830) do

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "snippets_count", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snippets", :force => true do |t|
    t.text     "body"
    t.text     "formatted_body"
    t.text     "formatted_preview"
    t.integer  "language_id",       :limit => 11
    t.string   "theme",                           :default => "clean"
    t.integer  "taggings_count",    :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",     :limit => 11
    t.integer  "snippet_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "taggings_count", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
