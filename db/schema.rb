# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_27_012319) do
  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recommand_item_id", null: false
    t.index ["recommand_item_id"], name: "index_comments_on_recommand_item_id"
  end

  create_table "recommand_items", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.text "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "item_type"
    t.string "og_title"
    t.text "og_description"
    t.text "og_image"
  end

  add_foreign_key "comments", "recommand_items"
end
