# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110523080730) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.string   "name_ru"
    t.string   "boss"
    t.string   "boss_ru"
    t.string   "salutation"
    t.string   "salutation_ru"
    t.integer  "order_by"
    t.boolean  "print"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["order_by"], :name => "index_departments_on_order_by"

  create_table "indices", :force => true do |t|
    t.string   "prefix"
    t.string   "description"
    t.integer  "last_number"
    t.integer  "relation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "indices", ["prefix"], :name => "index_indices_on_prefix"

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "order_by"
    t.boolean  "update_sent_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["order_by"], :name => "index_statuses_on_order_by"

end
