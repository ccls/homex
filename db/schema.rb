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

ActiveRecord::Schema.define(:version => 20110628194832) do

  create_table "exports", :force => true do |t|
    t.integer  "childid"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "diagnosis_date"
    t.integer  "patid"
    t.string   "type"
    t.string   "orderno"
    t.string   "mother_first_name"
    t.string   "mother_middle_name"
    t.string   "mother_last_name"
    t.string   "father_first_name"
    t.string   "father_middle_name"
    t.string   "father_last_name"
    t.string   "hospital_code"
    t.text     "comments"
    t.boolean  "is_eligible"
    t.boolean  "is_chosen"
    t.date     "reference_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exports", ["childid"], :name => "index_exports_on_childid", :unique => true
  add_index "exports", ["patid"], :name => "index_exports_on_patid", :unique => true

  create_table "guides", :force => true do |t|
    t.string   "controller"
    t.string   "action"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guides", ["controller", "action"], :name => "index_guides_on_controller_and_action", :unique => true

  create_table "imports", :force => true do |t|
    t.date     "dob"
    t.date     "diagnosis_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "sex"
    t.string   "language_code"
    t.boolean  "is_hispanic"
    t.string   "race"
    t.string   "primary_phone_number"
    t.string   "alternate_phone_number"
    t.date     "dust_kit_sent_on"
    t.date     "completed_interview_on"
    t.date     "case_assigned_on"
    t.string   "respondent_type"
    t.string   "respondent_first_name"
    t.string   "respondent_middle_name"
    t.string   "respondent_last_name"
    t.date     "last_action_on"
    t.string   "respondent_address_line_1"
    t.string   "respondent_address_line_2"
    t.string   "respondent_city"
    t.string   "respondent_state"
    t.string   "respondent_zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "position"
    t.integer  "parent_id"
    t.boolean  "hide_menu",  :default => false
    t.string   "path"
    t.string   "title_en"
    t.string   "title_es"
    t.string   "menu_en"
    t.string   "menu_es"
    t.text     "body_en"
    t.text     "body_es"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
  add_index "pages", ["path"], :name => "index_pages_on_path", :unique => true

  create_table "roles", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "sn"
    t.string   "displayname"
    t.string   "mail",            :default => "", :null => false
    t.string   "telephonenumber"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["sn"], :name => "index_users_on_sn"
  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

end
