# Extraction of answers from the survey
class HomeExposureResponse < ActiveRecord::Base
	belongs_to :subject, :foreign_key => 'study_subject_id'

	validates_presence_of   :study_subject_id
	validates_presence_of   :subject
	validates_uniqueness_of :study_subject_id

#	def self.q_column_names
#		column_names - 
#			%w( id subject_id childid created_at updated_at ) -
#			%w( vacuum_bag_last_changed vacuum_used_outside_home )
#	end

	#	could have just used column_names, but these
	#	are ordered to match the survey
	def self.field_names
		%w(
			vacuum_has_disposable_bag
			how_often_vacuumed_12mos
			shoes_usually_off_inside_12mos
			someone_ate_meat_12mos
			freq_pan_fried_meat_12mos
			freq_deep_fried_meat_12mos
			freq_oven_fried_meat_12mos
			freq_grilled_meat_outside_12mos
			freq_other_high_temp_cooking_12mos
			other_type_high_temp_cooking
			doneness_of_meat_exterior_12mos
			job_is_plane_mechanic_12mos
			job_is_artist_12mos
			job_is_janitor_12mos
			job_is_construction_12mos
			job_is_dentist_12mos
			job_is_electrician_12mos
			job_is_engineer_12mos
			job_is_farmer_12mos
			job_is_gardener_12mos
			job_is_lab_worker_12mos
			job_is_manufacturer_12mos
			job_auto_mechanic_12mos
			job_is_patient_care_12mos
			job_is_agr_packer_12mos
			job_is_painter_12mos
			job_is_pesticides_12mos
			job_is_photographer_12mos
			job_is_teacher_12mos
			job_is_welder_12mos
			used_flea_control_12mos
			freq_used_flea_control_12mos
			used_ant_control_12mos
			freq_ant_control_12mos
			used_bee_control_12mos
			freq_bee_control_12mos
			used_indoor_plant_prod_12mos
			freq_indoor_plant_product_12mos
			used_other_indoor_product_12mos
			freq_other_indoor_product_12mos
			used_indoor_foggers
			freq_indoor_foggers_12mos
			used_pro_pest_inside_12mos
			freq_pro_pest_inside_12mos
			used_pro_pest_outside_12mos
			freq_used_pro_pest_outside_12mos
			used_pro_lawn_service_12mos
			freq_pro_lawn_service_12mos
			used_lawn_products_12mos
			freq_lawn_products_12mos
			used_slug_control_12mos
			freq_slug_control_12mos
			used_rat_control_12mos
			freq_rat_control_12mos
			used_mothballs_12mos
			cmty_sprayed_gypsy_moths_12mos
			cmty_sprayed_medflies_12mos
			cmty_sprayed_mosquitoes_12mos
			cmty_sprayed_sharpshooters_12mos
			cmty_sprayed_apple_moths_12mos
			cmty_sprayed_other_pest_12mos
			other_pest_community_sprayed
			type_of_residence
			other_type_of_residence
			number_of_floors_in_residence
			number_of_stories_in_building
			year_home_built
			home_square_footage
			number_of_rooms_in_home
			home_constructed_of
			other_home_material
			home_has_attached_garage
			vehicle_in_garage_1mo
			freq_in_out_garage_1mo
			home_has_electric_cooling
			freq_windows_open_cold_mos_12mos
			freq_windows_open_warm_mos_12mos
			used_electric_heat_12mos
			used_kerosene_heat_12mos
			used_radiator_12mos
			used_gas_heat_12mos
			used_wood_burning_stove_12mos
			freq_used_wood_stove_12mos
			used_wood_fireplace_12mos
			freq_used_wood_fireplace_12mos
			used_fireplace_insert_12mos
			used_gas_stove_12mos
			used_gas_dryer_12mos
			used_gas_water_heater_12mos
			used_other_gas_appliance_12mos
			type_of_other_gas_appliance
			painted_inside_home
			carpeted_in_home
			refloored_in_home
			weather_proofed_home
			replaced_home_windows
			roof_work_on_home
			construction_in_home
			other_home_remodelling
			type_other_home_remodelling
			regularly_smoked_indoors
			regularly_smoked_indoors_12mos
			regularly_smoked_outdoors
			regularly_smoked_outdoors_12mos
			used_smokeless_tobacco_12mos
			qty_of_upholstered_furniture
			qty_bought_after_2006
			furniture_has_exposed_foam
			home_has_carpets
			percent_home_with_carpet
			home_has_televisions
			number_of_televisions_in_home
			avg_number_hours_tvs_used
			home_has_computers
			number_of_computers_in_home
			avg_number_hours_computers_used
			additional_comments
		)
	end

end
