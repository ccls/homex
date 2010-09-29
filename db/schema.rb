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

ActiveRecord::Schema.define(:version => 20100929164118) do

  create_table "address_types", :force => true do |t|
    t.integer  "position"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "address_types", ["code"], :name => "index_address_types_on_code", :unique => true

  create_table "addresses", :force => true do |t|
    t.integer  "address_type_id"
    t.integer  "data_source_id"
    t.string   "line_1"
    t.string   "line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "external_address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addressings", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "address_id"
    t.integer  "current_address"
    t.integer  "address_at_diagnosis"
    t.date     "valid_from"
    t.date     "valid_to"
    t.integer  "is_valid"
    t.string   "why_invalid"
    t.boolean  "is_verified"
    t.string   "how_verified"
    t.datetime "verified_on"
    t.integer  "verified_by_id"
    t.integer  "data_source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addressings", ["address_id"], :name => "index_addressings_on_address_id"
  add_index "addressings", ["subject_id"], :name => "index_addressings_on_subject_id"

  create_table "aliquot_sample_formats", :force => true do |t|
    t.integer  "position"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aliquot_sample_formats", ["code"], :name => "index_aliquot_sample_formats_on_code", :unique => true
  add_index "aliquot_sample_formats", ["description"], :name => "index_aliquot_sample_formats_on_description", :unique => true

  create_table "aliquots", :force => true do |t|
    t.integer  "position"
    t.integer  "owner_id"
    t.integer  "sample_id"
    t.integer  "unit_id"
    t.integer  "aliquot_sample_format_id"
    t.string   "location"
    t.string   "mass"
    t.string   "external_aliquot_id"
    t.string   "external_aliquot_id_source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aliquots", ["aliquot_sample_format_id"], :name => "index_aliquots_on_aliquot_sample_format_id"
  add_index "aliquots", ["owner_id"], :name => "index_aliquots_on_owner_id"
  add_index "aliquots", ["sample_id"], :name => "index_aliquots_on_sample_id"
  add_index "aliquots", ["unit_id"], :name => "index_aliquots_on_unit_id"

  create_table "analyses", :force => true do |t|
    t.integer  "analyst_id"
    t.integer  "project_id"
    t.string   "code",                           :null => false
    t.string   "description"
    t.integer  "analytic_file_creator_id"
    t.date     "analytic_file_created_date"
    t.date     "analytic_file_last_pulled_date"
    t.string   "analytic_file_location"
    t.string   "analytic_file_filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "analyses", ["code"], :name => "index_analyses_on_code", :unique => true

  create_table "analyses_subjects", :id => false, :force => true do |t|
    t.integer "analysis_id"
    t.integer "subject_id"
  end

  add_index "analyses_subjects", ["analysis_id"], :name => "index_analyses_subjects_on_analysis_id"
  add_index "analyses_subjects", ["subject_id"], :name => "index_analyses_subjects_on_subject_id"

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

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "contexts", :force => true do |t|
    t.integer  "position"
    t.string   "code",        :null => false
    t.string   "description"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contexts", ["code"], :name => "index_contexts_on_code", :unique => true
  add_index "contexts", ["description"], :name => "index_contexts_on_description", :unique => true

  create_table "data_sources", :force => true do |t|
    t.integer  "position"
    t.string   "research_origin"
    t.string   "data_origin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "diagnoses", :force => true do |t|
    t.integer  "position"
    t.integer  "code",        :null => false
    t.string   "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "diagnoses", ["code"], :name => "index_diagnoses_on_code", :unique => true
  add_index "diagnoses", ["description"], :name => "index_diagnoses_on_description", :unique => true

  create_table "document_types", :force => true do |t|
    t.integer  "position"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_versions", :force => true do |t|
    t.integer  "position"
    t.integer  "document_type_id", :null => false
    t.string   "title"
    t.string   "description"
    t.string   "indicator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.integer  "owner_id"
    t.string   "title",                                    :null => false
    t.text     "abstract"
    t.boolean  "shared_with_all",       :default => false, :null => false
    t.boolean  "shared_with_select",    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  add_index "documents", ["document_file_name"], :name => "index_documents_on_document_file_name", :unique => true
  add_index "documents", ["owner_id"], :name => "index_documents_on_owner_id"

  create_table "enrollments", :force => true do |t|
    t.integer  "position"
    t.integer  "subject_id"
    t.integer  "project_id"
    t.string   "recruitment_priority"
    t.integer  "able_to_locate"
    t.integer  "is_candidate"
    t.integer  "is_eligible"
    t.integer  "ineligible_reason_id"
    t.string   "ineligible_reason_specify"
    t.integer  "consented"
    t.date     "consented_on"
    t.integer  "refusal_reason_id"
    t.string   "other_refusal_reason"
    t.integer  "is_chosen"
    t.string   "reason_not_chosen"
    t.integer  "terminated_participation"
    t.string   "terminated_reason"
    t.integer  "is_complete"
    t.date     "completed_on"
    t.boolean  "is_closed"
    t.string   "reason_closed"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_version_id"
  end

  add_index "enrollments", ["project_id", "subject_id"], :name => "index_enrollments_on_project_id_and_subject_id", :unique => true

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

  create_table "home_exposure_responses", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "vacuum_has_disposable_bag"
    t.integer  "how_often_vacuumed_12mos"
    t.integer  "shoes_usually_off_inside_12mos"
    t.integer  "someone_ate_meat_12mos"
    t.integer  "freq_pan_fried_meat_12mos"
    t.integer  "freq_deep_fried_meat_12mos"
    t.integer  "freq_oven_fried_meat_12mos"
    t.integer  "freq_grilled_meat_outside_12mos"
    t.integer  "freq_other_high_temp_cooking_12mos"
    t.string   "other_type_high_temp_cooking"
    t.integer  "doneness_of_meat_exterior_12mos"
    t.integer  "job_is_plane_mechanic_12mos"
    t.integer  "job_is_artist_12mos"
    t.integer  "job_is_janitor_12mos"
    t.integer  "job_is_construction_12mos"
    t.integer  "job_is_dentist_12mos"
    t.integer  "job_is_electrician_12mos"
    t.integer  "job_is_engineer_12mos"
    t.integer  "job_is_farmer_12mos"
    t.integer  "job_is_gardener_12mos"
    t.integer  "job_is_lab_worker_12mos"
    t.integer  "job_is_manufacturer_12mos"
    t.integer  "job_auto_mechanic_12mos"
    t.integer  "job_is_patient_care_12mos"
    t.integer  "job_is_agr_packer_12mos"
    t.integer  "job_is_painter_12mos"
    t.integer  "job_is_pesticides_12mos"
    t.integer  "job_is_photographer_12mos"
    t.integer  "job_is_teacher_12mos"
    t.integer  "job_is_welder_12mos"
    t.integer  "used_flea_control_12mos"
    t.integer  "freq_used_flea_control_12mos"
    t.integer  "used_ant_control_12mos"
    t.integer  "freq_ant_control_12mos"
    t.integer  "used_bee_control_12mos"
    t.integer  "freq_bee_control_12mos"
    t.integer  "used_indoor_plant_prod_12mos"
    t.integer  "freq_indoor_plant_product_12mos"
    t.integer  "used_other_indoor_product_12mos"
    t.integer  "freq_other_indoor_product_12mos"
    t.integer  "used_indoor_foggers"
    t.integer  "freq_indoor_foggers_12mos"
    t.integer  "used_pro_pest_inside_12mos"
    t.integer  "freq_pro_pest_inside_12mos"
    t.integer  "used_pro_pest_outside_12mos"
    t.integer  "freq_used_pro_pest_outside_12mos"
    t.integer  "used_pro_lawn_service_12mos"
    t.integer  "freq_pro_lawn_service_12mos"
    t.integer  "used_lawn_products_12mos"
    t.integer  "freq_lawn_products_12mos"
    t.integer  "used_slug_control_12mos"
    t.integer  "freq_slug_control_12mos"
    t.integer  "used_rat_control_12mos"
    t.integer  "freq_rat_control_12mos"
    t.integer  "used_mothballs_12mos"
    t.integer  "cmty_sprayed_gypsy_moths_12mos"
    t.integer  "cmty_sprayed_medflies_12mos"
    t.integer  "cmty_sprayed_mosquitoes_12mos"
    t.integer  "cmty_sprayed_sharpshooters_12mos"
    t.integer  "cmty_sprayed_apple_moths_12mos"
    t.integer  "cmty_sprayed_other_pest_12mos"
    t.string   "other_pest_community_sprayed"
    t.integer  "type_of_residence"
    t.string   "other_type_of_residence"
    t.integer  "number_of_floors_in_residence"
    t.integer  "number_of_stories_in_building"
    t.integer  "year_home_built"
    t.integer  "home_square_footage"
    t.integer  "number_of_rooms_in_home"
    t.integer  "home_constructed_of"
    t.string   "other_home_material"
    t.integer  "home_has_attached_garage"
    t.integer  "vehicle_in_garage_1mo"
    t.integer  "freq_in_out_garage_1mo"
    t.integer  "home_has_electric_cooling"
    t.integer  "freq_windows_open_cold_mos_12mos"
    t.integer  "freq_windows_open_warm_mos_12mos"
    t.integer  "used_electric_heat_12mos"
    t.integer  "used_kerosene_heat_12mos"
    t.integer  "used_radiator_12mos"
    t.integer  "used_gas_heat_12mos"
    t.integer  "used_wood_burning_stove_12mos"
    t.integer  "freq_used_wood_stove_12mos"
    t.integer  "used_wood_fireplace_12mos"
    t.integer  "freq_used_wood_fireplace_12mos"
    t.integer  "used_fireplace_insert_12mos"
    t.integer  "used_gas_stove_12mos"
    t.integer  "used_gas_dryer_12mos"
    t.integer  "used_gas_water_heater_12mos"
    t.integer  "used_other_gas_appliance_12mos"
    t.string   "type_of_other_gas_appliance"
    t.integer  "painted_inside_home"
    t.integer  "carpeted_in_home"
    t.integer  "refloored_in_home"
    t.integer  "weather_proofed_home"
    t.integer  "replaced_home_windows"
    t.integer  "roof_work_on_home"
    t.integer  "construction_in_home"
    t.integer  "other_home_remodelling"
    t.string   "type_other_home_remodelling"
    t.integer  "regularly_smoked_indoors"
    t.integer  "regularly_smoked_indoors_12mos"
    t.integer  "regularly_smoked_outdoors"
    t.integer  "regularly_smoked_outdoors_12mos"
    t.integer  "used_smokeless_tobacco_12mos"
    t.integer  "qty_of_upholstered_furniture"
    t.integer  "qty_bought_after_2006"
    t.integer  "furniture_has_exposed_foam"
    t.integer  "home_has_carpets"
    t.integer  "percent_home_with_carpet"
    t.integer  "home_has_televisions"
    t.integer  "number_of_televisions_in_home"
    t.integer  "avg_number_hours_tvs_used"
    t.integer  "home_has_computers"
    t.integer  "number_of_computers_in_home"
    t.integer  "avg_number_hours_computers_used"
    t.text     "additional_comments"
    t.integer  "vacuum_bag_last_changed"
    t.integer  "vacuum_used_outside_home"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "home_exposure_responses", ["subject_id"], :name => "index_home_exposure_responses_on_subject_id", :unique => true

  create_table "home_page_pics", :force => true do |t|
    t.string   "title"
    t.text     "caption"
    t.boolean  "active",             :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "home_page_pics", ["active"], :name => "index_home_page_pics_on_active"

  create_table "homex_outcomes", :force => true do |t|
    t.integer  "position"
    t.integer  "subject_id"
    t.integer  "sample_outcome_id"
    t.datetime "sample_outcome_on"
    t.integer  "interview_outcome_id"
    t.datetime "interview_outcome_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "homex_outcomes", ["subject_id"], :name => "index_homex_outcomes_on_subject_id", :unique => true

  create_table "hospitals", :force => true do |t|
    t.integer  "position"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hospitals", ["organization_id"], :name => "index_hospitals_on_organization_id"

  create_table "identifiers", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "childid"
    t.integer  "patid"
    t.string   "case_control_type",    :limit => 1
    t.integer  "orderno"
    t.string   "lab_no"
    t.string   "related_childid"
    t.string   "related_case_childid"
    t.string   "ssn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subjectid",            :limit => 6
  end

  add_index "identifiers", ["patid", "case_control_type", "orderno"], :name => "piccton", :unique => true
  add_index "identifiers", ["ssn"], :name => "index_identifiers_on_ssn", :unique => true
  add_index "identifiers", ["subject_id"], :name => "index_identifiers_on_subject_id", :unique => true
  add_index "identifiers", ["subjectid"], :name => "index_identifiers_on_subjectid", :unique => true

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

  create_table "ineligible_reasons", :force => true do |t|
    t.integer  "position"
    t.string   "code",               :null => false
    t.string   "description"
    t.string   "ineligible_context"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ineligible_reasons", ["code"], :name => "index_ineligible_reasons_on_code", :unique => true
  add_index "ineligible_reasons", ["description"], :name => "index_ineligible_reasons_on_description", :unique => true

  create_table "instrument_versions", :force => true do |t|
    t.integer  "position"
    t.integer  "interview_type_id"
    t.integer  "language_id"
    t.date     "began_use_on"
    t.date     "ended_use_on"
    t.string   "code",              :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "instrument_id"
  end

  add_index "instrument_versions", ["code"], :name => "index_interview_versions_on_code", :unique => true
  add_index "instrument_versions", ["description"], :name => "index_interview_versions_on_description", :unique => true

  create_table "instruments", :force => true do |t|
    t.integer  "position"
    t.integer  "project_id",          :null => false
    t.integer  "results_table_id"
    t.string   "code",                :null => false
    t.string   "name",                :null => false
    t.string   "description"
    t.integer  "interview_method_id"
    t.date     "began_use_on"
    t.date     "ended_use_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instruments", ["code"], :name => "index_instruments_on_code", :unique => true
  add_index "instruments", ["description"], :name => "index_instruments_on_description", :unique => true
  add_index "instruments", ["project_id"], :name => "index_instruments_on_project_id"

  create_table "interview_methods", :force => true do |t|
    t.integer  "position"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interview_methods", ["code"], :name => "index_interview_methods_on_code", :unique => true

  create_table "interview_outcomes", :force => true do |t|
    t.integer  "position"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interview_outcomes", ["code"], :name => "index_interview_outcomes_on_code", :unique => true

  create_table "interview_types", :force => true do |t|
    t.integer  "position"
    t.integer  "project_id"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interview_types", ["code"], :name => "index_interview_types_on_code", :unique => true
  add_index "interview_types", ["description"], :name => "index_interview_types_on_description", :unique => true

  create_table "interviews", :force => true do |t|
    t.integer  "position"
    t.integer  "identifier_id"
    t.integer  "address_id"
    t.integer  "interviewer_id"
    t.integer  "instrument_version_id"
    t.integer  "interview_method_id"
    t.integer  "language_id"
    t.date     "began_on"
    t.date     "ended_on"
    t.string   "respondent_first_name"
    t.string   "respondent_last_name"
    t.integer  "respondent_relationship_id"
    t.string   "respondent_relationship_other"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.integer  "position"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["code"], :name => "index_languages_on_code", :unique => true

  create_table "operational_event_types", :force => true do |t|
    t.integer  "position"
    t.integer  "project_id"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "operational_event_types", ["code"], :name => "index_operational_event_types_on_code", :unique => true
  add_index "operational_event_types", ["description"], :name => "index_operational_event_types_on_description", :unique => true

  create_table "operational_events", :force => true do |t|
    t.integer  "operational_event_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "occurred_on"
    t.integer  "enrollment_id"
    t.string   "description"
  end

  create_table "organizations", :force => true do |t|
    t.integer  "position"
    t.string   "code",       :limit => 15
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
  end

  add_index "organizations", ["code"], :name => "index_organizations_on_code", :unique => true
  add_index "organizations", ["name"], :name => "index_organizations_on_name", :unique => true

  create_table "packages", :force => true do |t|
    t.integer  "position"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tracks_count",    :default => 0
    t.string   "tracking_number"
    t.string   "latest_event"
  end

  add_index "packages", ["tracking_number"], :name => "index_packages_on_tracking_number", :unique => true

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

  create_table "patients", :force => true do |t|
    t.integer  "subject_id"
    t.date     "diagnosis_date"
    t.integer  "hospital_no"
    t.integer  "diagnosis_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
  end

  add_index "patients", ["organization_id"], :name => "index_patients_on_organization_id"
  add_index "patients", ["subject_id"], :name => "index_patients_on_subject_id", :unique => true

  create_table "people", :force => true do |t|
    t.integer  "position"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "honorific",      :limit => 20
    t.integer  "person_type_id"
  end

  create_table "phone_numbers", :force => true do |t|
    t.integer  "position"
    t.integer  "subject_id"
    t.integer  "phone_type_id"
    t.integer  "data_source_id"
    t.string   "phone_number"
    t.boolean  "is_primary"
    t.integer  "is_valid"
    t.string   "why_invalid"
    t.boolean  "is_verified"
    t.string   "how_verified"
    t.datetime "verified_on"
    t.integer  "verified_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phone_numbers", ["subject_id"], :name => "index_phone_numbers_on_subject_id"

  create_table "phone_types", :force => true do |t|
    t.integer  "position"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phone_types", ["code"], :name => "index_phone_types_on_code", :unique => true

  create_table "photos", :force => true do |t|
    t.string   "title",              :null => false
    t.text     "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "piis", :force => true do |t|
    t.integer  "subject_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "dob"
    t.date     "died_on"
    t.string   "state_id_no"
    t.string   "mother_first_name"
    t.string   "mother_middle_name"
    t.string   "mother_maiden_name"
    t.string   "mother_last_name"
    t.string   "father_first_name"
    t.string   "father_middle_name"
    t.string   "father_last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "piis", ["email"], :name => "index_piis_on_email", :unique => true
  add_index "piis", ["state_id_no"], :name => "index_piis_on_state_id_no", :unique => true
  add_index "piis", ["subject_id"], :name => "index_piis_on_subject_id", :unique => true

  create_table "project_outcomes", :force => true do |t|
    t.integer  "position"
    t.integer  "project_id"
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "position"
    t.date     "began_on"
    t.date     "ended_on"
    t.string   "code"
    t.string   "description"
    t.text     "eligibility_criteria"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["code"], :name => "index_projects_on_code", :unique => true
  add_index "projects", ["description"], :name => "index_projects_on_description", :unique => true

  create_table "projects_samples", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "sample_id"
  end

  add_index "projects_samples", ["project_id"], :name => "index_projects_samples_on_project_id"
  add_index "projects_samples", ["sample_id"], :name => "index_projects_samples_on_sample_id"

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

  create_table "races", :force => true do |t|
    t.integer  "position"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "races", ["code"], :name => "index_races_on_code", :unique => true
  add_index "races", ["description"], :name => "index_races_on_description", :unique => true

  create_table "refusal_reasons", :force => true do |t|
    t.integer  "position"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refusal_reasons", ["code"], :name => "index_refusal_reasons_on_code", :unique => true
  add_index "refusal_reasons", ["description"], :name => "index_refusal_reasons_on_description", :unique => true

  create_table "response_sets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.integer  "subject_id"
    t.string   "access_code"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "response_sets", ["access_code"], :name => "index_response_sets_on_access_code", :unique => true
  add_index "response_sets", ["access_code"], :name => "response_sets_ac_idx", :unique => true
  add_index "response_sets", ["subject_id"], :name => "index_response_sets_on_subject_id"

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

  create_table "sample_kits", :force => true do |t|
    t.integer  "sample_id"
    t.integer  "kit_package_id"
    t.integer  "sample_package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sample_outcomes", :force => true do |t|
    t.integer  "position"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sample_outcomes", ["code"], :name => "index_sample_outcomes_on_code", :unique => true

  create_table "sample_types", :force => true do |t|
    t.integer  "position"
    t.integer  "parent_id"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sample_types", ["code"], :name => "index_sample_types_on_code", :unique => true
  add_index "sample_types", ["description"], :name => "index_sample_types_on_description", :unique => true
  add_index "sample_types", ["parent_id"], :name => "index_sample_types_on_parent_id"

  create_table "samples", :force => true do |t|
    t.integer  "position"
    t.integer  "aliquot_sample_format_id"
    t.integer  "sample_type_id"
    t.integer  "subject_id"
    t.integer  "unit_id"
    t.integer  "order_no",                                                                  :default => 1
    t.integer  "quantity_in_sample",           :limit => 10, :precision => 10, :scale => 0
    t.string   "aliquot_or_sample_on_receipt",                                              :default => "Sample"
    t.date     "sent_to_subject_on"
    t.date     "received_by_ccls_on"
    t.date     "sent_to_lab_on"
    t.date     "received_by_lab_on"
    t.date     "aliquotted_on"
    t.string   "external_id"
    t.string   "external_id_source"
    t.date     "receipt_confirmed_on"
    t.string   "receipt_confirmed_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", :force => true do |t|
    t.integer  "position"
    t.string   "code",                           :null => false
    t.string   "name",                           :null => false
    t.string   "fips_country_code", :limit => 2, :null => false
    t.string   "fips_state_code",   :limit => 2, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["code"], :name => "index_states_on_code", :unique => true
  add_index "states", ["fips_country_code"], :name => "index_states_on_fips_country_code"
  add_index "states", ["fips_state_code"], :name => "index_states_on_fips_state_code", :unique => true
  add_index "states", ["name"], :name => "index_states_on_name", :unique => true

  create_table "subject_types", :force => true do |t|
    t.integer  "position"
    t.string   "code",                      :null => false
    t.string   "description"
    t.string   "related_case_control_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_types", ["code"], :name => "index_subject_types_on_code", :unique => true
  add_index "subject_types", ["description"], :name => "index_subject_types_on_description", :unique => true

  create_table "subjects", :force => true do |t|
    t.integer  "subject_type_id"
    t.integer  "race_id"
    t.integer  "vital_status_id"
    t.integer  "hispanicity_id"
    t.date     "reference_date"
    t.integer  "response_sets_count",              :default => 0
    t.string   "sex"
    t.boolean  "do_not_contact",                   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "matchingid",          :limit => 6
    t.string   "familyid",            :limit => 6
  end

  add_index "subjects", ["familyid"], :name => "index_subjects_on_familyid", :unique => true
  add_index "subjects", ["matchingid"], :name => "index_subjects_on_matchingid", :unique => true

  create_table "survey_invitations", :force => true do |t|
    t.integer  "subject_id",      :null => false
    t.integer  "response_set_id"
    t.integer  "survey_id"
    t.string   "token",           :null => false
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_invitations", ["survey_id", "subject_id"], :name => "index_survey_invitations_on_survey_id_and_subject_id", :unique => true
  add_index "survey_invitations", ["token"], :name => "index_survey_invitations_on_token", :unique => true

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

  create_table "tracks", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.string   "name"
    t.string   "location"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tracks", ["trackable_id", "trackable_type", "time"], :name => "index_tracks_on_trackable_id_and_trackable_type_and_time", :unique => true

  create_table "transfers", :force => true do |t|
    t.integer  "position"
    t.integer  "aliquot_id"
    t.integer  "from_organization_id",                                              :null => false
    t.integer  "to_organization_id",                                                :null => false
    t.integer  "amount",               :limit => 10, :precision => 10, :scale => 0
    t.string   "reason"
    t.boolean  "is_permanent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transfers", ["aliquot_id"], :name => "index_transfers_on_aliquot_id"
  add_index "transfers", ["from_organization_id"], :name => "index_transfers_on_from_organization_id"
  add_index "transfers", ["to_organization_id"], :name => "index_transfers_on_to_organization_id"

  create_table "units", :force => true do |t|
    t.integer  "position"
    t.integer  "context_id"
    t.string   "code",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["code"], :name => "index_units_on_code", :unique => true
  add_index "units", ["description"], :name => "index_units_on_description", :unique => true

  create_table "user_invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "email"
    t.string   "token"
    t.datetime "accepted_at"
    t.integer  "recipient_id"
    t.text     "message"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "vital_statuses", :force => true do |t|
    t.integer  "position"
    t.integer  "code",        :null => false
    t.string   "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vital_statuses", ["code"], :name => "index_vital_statuses_on_code", :unique => true

end
