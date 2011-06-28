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

ActiveRecord::Schema.define(:version => 20110628194013) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.integer  "weight"
    t.string   "response_class"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.boolean  "is_exclusive"
    t.boolean  "hide_label"
    t.integer  "display_length"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["data_export_identifier"], :name => "index_answers_on_data_export_identifier"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "dependencies", :force => true do |t|
    t.integer  "question_id"
    t.integer  "question_group_id"
    t.string   "rule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dependencies", ["question_id"], :name => "index_dependencies_on_question_id"

  create_table "dependency_conditions", :force => true do |t|
    t.integer  "dependency_id"
    t.string   "rule_key"
    t.integer  "question_id"
    t.string   "operator"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dependency_conditions", ["dependency_id"], :name => "index_dependency_conditions_on_dependency_id"
  add_index "dependency_conditions", ["question_id"], :name => "index_dependency_conditions_on_question_id"

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

  create_table "question_groups", :force => true do |t|
    t.text     "text"
    t.text     "help_text"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.string   "display_type"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer  "survey_section_id"
    t.integer  "question_group_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.string   "pick"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "display_type"
    t.boolean  "is_mandatory"
    t.integer  "display_width"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "correct_answer_id"
    t.string   "number"
  end

  add_index "questions", ["data_export_identifier"], :name => "index_questions_on_data_export_identifier"
  add_index "questions", ["survey_section_id"], :name => "index_questions_on_survey_section_id"

  create_table "response_sets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.integer  "study_subject_id"
    t.string   "access_code"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "response_sets", ["access_code"], :name => "index_response_sets_on_access_code", :unique => true
  add_index "response_sets", ["access_code"], :name => "response_sets_ac_idx", :unique => true
  add_index "response_sets", ["study_subject_id"], :name => "index_response_sets_on_study_subject_id"

  create_table "responses", :force => true do |t|
    t.integer  "response_set_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "response_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["response_set_id"], :name => "index_responses_on_response_set_id"

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

  create_table "survey_sections", :force => true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.text     "description"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "custom_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_sections", ["survey_id"], :name => "index_survey_sections_on_survey_id"

  create_table "surveys", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "access_code"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.datetime "active_at"
    t.datetime "inactive_at"
    t.string   "css_url"
    t.string   "custom_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "display_order"
    t.boolean  "manual_numbering"
  end

  add_index "surveys", ["access_code"], :name => "index_surveys_on_access_code", :unique => true
  add_index "surveys", ["access_code"], :name => "surveys_ac_idx", :unique => true

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

  create_table "validation_conditions", :force => true do |t|
    t.integer  "validation_id"
    t.string   "rule_key"
    t.string   "operator"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "regexp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "validation_conditions", ["validation_id"], :name => "index_validation_conditions_on_validation_id"

  create_table "validations", :force => true do |t|
    t.integer  "answer_id"
    t.string   "rule"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "validations", ["answer_id"], :name => "index_validations_on_answer_id"

end
