# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120605113030) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.string   "name_ru"
    t.string   "boss"
    t.string   "boss_ru"
    t.string   "salutation"
    t.string   "salutation_ru"
    t.integer  "order_by"
    t.boolean  "print"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "departments", ["order_by"], :name => "index_departments_on_order_by"

  create_table "employees", :force => true do |t|
    t.integer  "department_id"
    t.string   "name"
    t.string   "name_ru"
    t.boolean  "print"
    t.integer  "order_by"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "department_ka"
    t.string   "department_ru"
  end

  add_index "employees", ["order_by"], :name => "index_employees_on_order_by"

  create_table "indices", :force => true do |t|
    t.string   "prefix"
    t.string   "description"
    t.integer  "last_number"
    t.integer  "relation_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "indices", ["prefix"], :name => "index_indices_on_prefix"

  create_table "letter_departments", :force => true do |t|
    t.integer  "letter_id"
    t.integer  "department_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "letter_departments", ["letter_id", "department_id"], :name => "index_letter_departments_on_letter_id_and_department_id"

  create_table "letter_employees", :force => true do |t|
    t.integer  "letter_id"
    t.integer  "employee_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "letter_employees", ["letter_id", "employee_id"], :name => "index_letter_employees_on_letter_id_and_employee_id"

  create_table "letters", :force => true do |t|
    t.string   "own_number"
    t.string   "number"
    t.integer  "index_id"
    t.integer  "status_id"
    t.date     "received"
    t.date     "sent"
    t.string   "description"
    t.string   "name"
    t.string   "phone"
    t.string   "address"
    t.string   "custnumb"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "year"
    t.boolean  "is_empl_assigned"
    t.boolean  "is_dept_assigned"
    t.text     "resolution"
  end

  add_index "letters", ["index_id"], :name => "index_letters_on_index_id"
  add_index "letters", ["status_id"], :name => "index_letters_on_status_id"
  add_index "letters", ["year"], :name => "index_letters_on_year"

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "order_by"
    t.boolean  "update_sent_date"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "statuses", ["order_by"], :name => "index_statuses_on_order_by"

  create_table "user_indices", :force => true do |t|
    t.integer  "user_id"
    t.integer  "index_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_indices", ["index_id"], :name => "index_user_indices_on_index_id"
  add_index "user_indices", ["user_id"], :name => "index_user_indices_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.boolean  "admin"
    t.boolean  "canc_empl"
    t.integer  "department_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "users", ["department_id"], :name => "index_users_on_department_id"
  add_index "users", ["name"], :name => "index_users_on_name"

end
