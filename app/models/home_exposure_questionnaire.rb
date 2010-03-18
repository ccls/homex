class HomeExposureQuestionnaire < ActiveRecord::Base

	YNDK = [
		[ "Yes", 1 ],
		[ "No", 2 ],
		[ "Don't Know", 9 ]
	]

	validates_numericality_of :number_of_floors_in_residence,
			:number_of_stories_in_building,
			:home_square_footage,
			:number_of_rooms_in_residence,
			:number_of_televisions_in_home,
			:number_of_computers_in_home,
		:greater_than_or_equal_to => 0

	cattr_reader :vacuum_has_disposable_bag_options,
		:how_often_vacuumed_12mos_options,
		:shoes_usually_off_inside_12mos_options,
		:someone_ate_meat_12mos_options,
		:freq_pan_fried_meat_12mos_options,
		:freq_deep_fried_meat_12mos_options,
		:freq_oven_fried_meat_12mos_options,
		:freq_grilled_meat_outside_12mos_options,
		:freq_other_high_temp_cooking_12mos_options,
#		:other_type_high_temp_cooking_options,
		:doneness_of_meat_exterior_12mos_options,
		:job_is_plane_mechanic_12mos_options,
		:job_is_artist_12mos_options,
		:job_is_janitor_12mos_options,
		:job_is_construction_12mos_options,
		:job_is_dentist_12mos_options,
		:job_is_electrician_12mos_options,
		:job_is_engineer_12mos_options,
		:job_is_farmer_12mos_options,
		:job_is_gardener_12mos_options,
		:job_is_lab_worker_12mos_options,
		:job_is_manufacturer_12mos_options,
		:job_auto_mechanic_12mos_options,
		:job_is_patient_care_12mos_options,
		:job_is_agr_packer_12mos_options,
		:job_is_painter_12mos_options,
		:job_is_pesticides_12mos_options,
		:job_is_photographer_12mos_options,
		:job_is_teacher_12mos_options,
		:job_is_welder_12mos_options,
		:pet_treated_for_fleas_12mos_options,
		:freq_pet_treated_for_fleas_12mos_options,
		:used_ant_control_12mos_options,
		:freq_ant_control_12mos_options,
		:used_bee_control_12mos_options,
		:freq_bee_control_12mos_options,
		:used_indoor_plant_prod_12mos_options,
		:freq_indoor_plant_product_12mos_options,
		:treated_other_indoor_pest_12mos_options,
		:freq_other_indoor_pest_12mos_options,
		:used_indoor_foggers_options,
		:freq_indoor_foggers_12mos_options,
		:used_pro_pest_inside_12mos_options,
		:freq_pro_pest_inside_12mos_options,
		:used_pro_pest_outside_12mos_options,
		:freq_used_pro_pest_outside_12mos_options,
		:used_pro_lawn_service_12mos_options,
		:freq_pro_lawn_service_12mos_options,
		:used_lawn_products_12mos_options,
		:freq_lawn_products_12mos_options,
		:used_slug_control_12mos_options,
		:freq_slug_control_12mos_options,
		:used_rat_control_12mos_options,
		:freq_rat_control_12mos_options,
		:used_mothballs_12mos_options,
		:cmty_sprayed_moths_12mos_options,
		:cmty_sprayed_medflies_12mos_options,
		:cmty_sprayed_mosquitoes_12mos_options,
		:cmty_sprayed_sharpshooter_12mos_options,
		:cmty_sprayed_moth_12mos_options,
		:cmty_sprayed_other_pest_12mos_options,
#		:other_pest_community_sprayed_options,
		:type_of_residence_options,
#		:other_type_of_residence_options,
#		:number_of_floors_in_residence_options,
#		:number_of_stories_in_building_options,
#		:year_home_built_options,
#		:home_square_footage_options,
#		:number_of_rooms_in_residence_options,
		:home_constructed_of_options,
#		:other_home_material_options,
		:home_has_attached_garage_options,
		:vehicle_in_garage_1mo_options,
		:freq_in_out_garage_1mo_options,
		:home_has_electric_cooling_options,
		:freq_windows_open_cold_mos_12mos_options,
		:freq_windows_open_warm_mos_12mos_options,
		:used_electric_heat_12mos_options,
		:used_kerosene_heat_12mos_options,
		:used_radiator_12mos_options,
		:used_gas_heat_12mos_options,
		:used_wood_burning_stove_12mos_options,
		:freq_used_heat_12mos_options,
		:used_wood_fireplace_12mos_options,
		:freq_burned_wood_12mos_options,
		:used_fireplace_insert_12mos_options,
		:used_gas_stove_12mos_options,
		:used_gas_dryer_12mos_options,
		:used_gas_water_heater_12mos_options,
		:used_other_gas_appliance_12mos_options,
#		:type_of_other_gas_appliance_options,
		:painted_inside_home_options,
		:carpeted_in_home_options,
		:refloored_in_home_options,
		:weather_proofed_home_options,
		:replaced_home_windows_options,
		:roof_work_on_home_options,
		:construction_in_home_options,
		:other_home_remodelling_options,
#		:type_other_home_remodelling_options,
		:regularly_smoked_indoors_options,
		:regularly_smoked_indoors_12mos_options,
		:regularly_smoked_outdoors_options,
		:regularly_smoked_outdoors_12mos_options,
		:used_smokeless_tobacco_12mos_options,
		:qty_of_stuffed_furniture_options,
		:qty_bought_after_2006_options,
		:furniture_has_exposed_foam_options,
		:home_has_carpets_options,
		:percent_home_with_carpet_options,
		:home_has_televisions_options,
#		:number_of_televisions_in_home_options,
		:avg_number_hours_tvs_used_options,
		:home_has_computers_options,
#		:number_of_computers_in_home_options,
		:avg_number_hours_computers_used_options
#		:additional_comments_options


	@@vacuum_has_disposable_bag_options = {
		:question => "1. Does your vacuum cleaner have a disposable bag?",
		:answers => YNDK
	}
	@@how_often_vacuumed_12mos_options = {
		:question => "2. In the last 12 months, on average, how often were the rugs and floors in this home usually vacuumed?  Would you say…",
		:answers => [
			[ "Less than once a month", 1 ],
			[ "1-3 times a month", 2 ],
			[ "Once a week", 3 ],
			[ "More than once a week?", 4 ],
			[ "Don't Know", 9 ]
		] 
	}
	@@shoes_usually_off_inside_12mos_options = {
		:question => "3.              In the last 12 months, did all of the people who lived in this home usually take off their shoes when entering the home?",
		:answers  => YNDK
	}
	@@someone_ate_meat_12mos_options = {
		:question => "4.               During the last 12 months, did you or anyone else in your home eat hamburger, steak, pork, chicken or other meat products?",
		:answers  => YNDK
	}
#	5
	OSRN = [
		[ "Often", 1 ],
		[ "Sometimes", 2 ],
		[ "Rarely", 3 ],
		[ "Never", 4 ]
	]
	@@freq_pan_fried_meat_12mos_options = {
		:question => "5a. Pan fry (very hot)    ",
		:answers => OSRN
	}
	@@freq_deep_fried_meat_12mos_options = {
		:question => " 5b. Deep fry ",
		:answers => OSRN
	}
	@@freq_oven_fried_meat_12mos_options = {
		:question => "5c. Oven broil    ",
		:answers => OSRN
	}
	@@freq_grilled_meat_outside_12mos_options = {
		:question => "5d. Grill or barbeque (outside)    ",
		:answers => OSRN
	}
	@@freq_other_high_temp_cooking_12mos_options = {
		:question => " 5e. Other:",
		:answers => OSRN
	}
#	@@other_type_high_temp_cooking_options = YNDK

# 6
	@@doneness_of_meat_exterior_12mos_options = {
		:question => "6.               During the last 12 months, when you or other household members ate meat products, how well were they usually cooked on the outside? Would you say…",
		:answers => [
			[ "Not browned", 1 ],
			[ "Lightly-browned", 2 ],
			[ "Well-browned", 3 ],
			[ "Black or charred", 4 ],
			[ "It varies (volunteered code)", 5 ],
			[ "Don't Know", 9 ]
		]
	}
	@@job_is_plane_mechanic_12mos_options = {
		:question => "1 = Airplane Mechanic       ",
		:answers  => YNDK
	}
	@@job_is_artist_12mos_options = {
		:question => "2 = Artist/Art Teacher",
		:answers  => YNDK
	}
	@@job_is_janitor_12mos_options = {
		:question => "3 = Cleaner/Janitor  ",
		:answers  => YNDK
	}
	@@job_is_construction_12mos_options = {
		:question => "4 = Construction Worker/Carpenter       ",
		:answers  => YNDK
	}
	@@job_is_dentist_12mos_options = {
		:question => "5 = Dentist/Dental Woker     ",
		:answers  => YNDK
	}
	@@job_is_electrician_12mos_options = {
		:question => "6 = Electrician/Lineman/Cable puller ",
		:answers  => YNDK
	}
	@@job_is_engineer_12mos_options = {
		:question => "7 = Engineer/ Environmental Scientist ",
		:answers  => YNDK
	}
	@@job_is_farmer_12mos_options = {
		:question => "8 = Farmer/Farm or Ranch Worker     ",
		:answers  => YNDK
	}
	@@job_is_gardener_12mos_options = {
		:question => "9 = Gardner/ Groundskeeper /Landscaper/Nursery worker",
		:answers  => YNDK
	}
	@@job_is_lab_worker_12mos_options = {
		:question => "10 = Laboratory worker/ Lab ScienceTeacher ",
		:answers  => YNDK
	}
	@@job_is_manufacturer_12mos_options = {
		:question => "11 = Manufacturing/ Assembly/ Industrial operations/Product repair",
		:answers  => YNDK
	}
	@@job_auto_mechanic_12mos_options = {
		:question => "12 = Mechanic-auto/truck/bus",
		:answers  => YNDK
	}
	@@job_is_patient_care_12mos_options = {
		:question => "13 = Medical Patient Care Worker  ",
		:answers  => YNDK
	}
	@@job_is_agr_packer_12mos_options = {
		:question => "14 = Packer – Agricultural",
		:answers  => YNDK
	}
	@@job_is_painter_12mos_options = {
		:question => "15 = Painter/Wallpaperer ",
		:answers  => YNDK
	}
	@@job_is_pesticides_12mos_options = {
		:question => "16 = Pesticiding Handling/Production/ Formulation or Mixing",
		:answers  => YNDK
	}
	@@job_is_photographer_12mos_options = {
		:question => "17 = Photographer/ Framer/ Photography Teacher  ",
		:answers  => YNDK
	}
	@@job_is_teacher_12mos_options = {
		:question => "18 = Teacher-- Preschool to 5th Grade",
		:answers  => YNDK
	}
	@@job_is_welder_12mos_options = {
		:question => "19 = Welder/Joiner ",
		:answers  => YNDK
	}
# 8
	@@pet_treated_for_fleas_12mos_options = {
		:question => "8.              During the last 12 months, did you have a pet that was treated for fleas or ticks using shampoos, soaps, collars, sprays, dusts, powders, or skin applications?",
		:answers  => YNDK
	}
	FREQ1 = [
		[ "5 or more time", 1 ],
		[ "Less than 5 times", 2 ]
	]
	@@freq_pet_treated_for_fleas_12mos_options = {
		:question => "8a.              How often during the past 12 months? Would you say…",
		:answers => FREQ1
	}
	@@used_ant_control_12mos_options = {
		:question => "9.              During the last 12 months, have you or anyone else in your home used ant, fly, or cockroach control products in or around the house? ",
		:answers  => YNDK
	}
	@@freq_ant_control_12mos_options = {
		:question => "9a.              How often during the past 12 months?  Would you say….",
		:answers => FREQ1
	}
# 10
	@@used_bee_control_12mos_options = {
		:question => "10.              During the last 12 months, have you or anyone else in your home used bee, wasp, or hornet control products in or around the house?",
		:answers  => YNDK
	}
	@@freq_bee_control_12mos_options = {
		:question => "10a.              How often during the past 12 months?  Would you say….  ",
		:answers => FREQ1
	}
	@@used_indoor_plant_prod_12mos_options = {
		:question => "11.    During the last 12 months, did you or anyone in your home use any products to control indoor plant insects or  diseases?",
		:answers  => YNDK
	}
	@@freq_indoor_plant_product_12mos_options = {
		:question => "11a.              How often during the past 12 months?  Would you say….  ",
		:answers => FREQ1
	}
	@@treated_other_indoor_pest_12mos_options = {
		:question => "12.              During the last 12 months, did you or anyone in your home treat any other indoor insects or other types of pests?  Do not include products applied outside on your lawn, garden, or trees.",
		:answers  => YNDK
	}
	@@freq_other_indoor_pest_12mos_options = {
		:question => "12a.              How often during the past 12 months?  Would you say….  ",
		:answers => FREQ1
	}
	@@used_indoor_foggers_options = {
		:question => "13.              During the last 12 months, have you or anyone else in your home used indoor foggers or bombs?",
		:answers  => YNDK
	}
	@@freq_indoor_foggers_12mos_options = {
		:question => "13a.              How often during the past 12 months?  Would you say….  ",
		:answers => FREQ1
	}
	@@used_pro_pest_inside_12mos_options = {
		:question => "14.              During the last 12 months has a professional pest control person or exterminator applied products inside this dwelling?",
		:answers  => YNDK
	}
	@@freq_pro_pest_inside_12mos_options = {
		:question => "14a.              How often during the past 12 months?  Would you say….  ",
		:answers => FREQ1
	}
	@@used_pro_pest_outside_12mos_options = {
		:question => "15.               During the last 12 months, has a professional pest control person or exterminator applied products on the exterior or foundation of this dwelling?",
		:answers  => YNDK
	}
	@@freq_used_pro_pest_outside_12mos_options = {
		:question => "15a.              How often during the past 12 months?  Would you say…. ",
		:answers => FREQ1
	}
	@@used_pro_lawn_service_12mos_options = {
		:question => "16.              During the last 12 months, has a professional lawn or landscape service treated the lawn, garden, trees or other outdoor plants with products to control weeds, insects, or plant diseases? ",
		:answers  => YNDK
	}
	@@freq_pro_lawn_service_12mos_options = {
		:question => "16a.              How often during the past 12 months?  Would you say…. ",
		:answers => FREQ1
	}
	@@used_lawn_products_12mos_options = {
		:question => "17.              In the last 12 months, did you or anyone in your home treat the lawn, garden, trees, or other outdoor plants with products to control weeds, insects, or plant diseases?",
		:answers  => YNDK
	}
	@@freq_lawn_products_12mos_options = {
		:question => "17a.              How often during the past 12 months?  Would you say…. ",
		:answers => FREQ1
	}
	@@used_slug_control_12mos_options = {
		:question => "18.              In the last 12 months, did you or anyone in your home use products to control slugs or snails?",
		:answers  => YNDK
	}
	@@freq_slug_control_12mos_options = {
		:question => "18a.              How often during the past 12 months?  Would you say….",
		:answers => FREQ1
	}
	@@used_rat_control_12mos_options = {
		:question => "19.              Not including traps, in the last 12 months, did you or anyone in your home use products to control rats, mice, gophers or moles?",
		:answers  => YNDK
	}
	@@freq_rat_control_12mos_options = {
		:question => "19a.              How often during the past 12 months?  Would you say….  ",
		:answers => FREQ1
	}
# 20
	@@used_mothballs_12mos_options = {
		:question => "20.              In the last 12 months, have mothballs been used in your home?",
		:answers  => YNDK
	}
	@@cmty_sprayed_moths_12mos_options = {
		:question => "1 = Gypsy moths ",
		:answers  => YNDK
	}
	@@cmty_sprayed_medflies_12mos_options = {
		:question => "2 = Mediterranean fruit flies      ",
		:answers  => YNDK
	}
	@@cmty_sprayed_mosquitoes_12mos_options = {
		:question => "3 = Mosquitoes  ",
		:answers  => YNDK
	}
	@@cmty_sprayed_sharpshooter_12mos_options = {
		:question => "4 = Glassy Winged Sharpshooter  ",
		:answers  => YNDK
	}
	@@cmty_sprayed_moth_12mos_options = {
		:question => "5 = Light Brown Apple Moth",
		:answers  => YNDK
	}
	@@cmty_sprayed_other_pest_12mos_options = {
		:question => "8 = Some Other insect   (specify)",
		:answers  => YNDK
	}
#	@@other_pest_community_sprayed_options = YNDK

	@@type_of_residence_options = {
		:question => "22.              Which of the following best describes this residence? ",
		:answers  => [
			[ "Single family residence", 1 ],
			[ "Duplex / Townhouse", 2 ],
			[ "Apartment / Condominium", 3 ],
			[ "Mobile Home", 4 ],
			[ "Other (specify)", 8 ],
			[ "Don't Know", 9 ]
		]
	}
#	@@other_type_of_residence_options = YNDK
#	@@number_of_floors_in_residence_options = YNDK
#	@@number_of_stories_in_building_options = YNDK
#	@@year_home_built_options = YNDK
#	@@home_square_footage_options = YNDK
#	@@number_of_rooms_in_residence_options = YNDK
# 26
	@@home_constructed_of_options = {
		:question => "26.              Is your residence mostly constructed of?  ",
		:answers  => [
			[ "Wood", 1 ],
			[ "Mason / Brick / Cement", 2 ],
			[ "Pre-fabricated panels", 3 ],
			[ "Something Else (specify)", 8 ],
			[ "Don't Know", 9 ]
		]
	}
#	@@other_home_material_options = YNDK
	YN = [
		[ "Yes", 1 ],
		[ "No", 2 ]
	]
	@@home_has_attached_garage_options = {
		:question => "27.              Does this home have an attached garage?  (An attached garage has a door connecting directly to the house.)",
		:answers  => YN
	}
	@@vehicle_in_garage_1mo_options = {
		:question => "27a.              Has there been a car or motorcycle parked in the attached garage during the past month?",
		:answers  => YN
	}
# 27b
	FREQ2 = [
		[ "Every day (or almost every day)", 1 ],
		[ "1-2 times per week", 2 ],
		[ "1-2 times per month", 3 ],
		[ "less than one time per month", 4 ],
		[ "Never?", 5 ],
		[ "Don't Know", 9 ]
	]
	@@freq_in_out_garage_1mo_options = {
		:question => "27b.              How often was the car or motorcycle moved in and out of garage during the past month?

Would you say...",
		:answers => FREQ2
	}
	@@home_has_electric_cooling_options = {
		:question => "28.              Does this residence have any type of electric cooling system such as air conditioning? ",
		:answers  => YN
	}
	FREQ3 = [
		[ "Every day or almost everyday", 1 ],
		[ "About once a week", 2 ],
		[ "A few times a month", 3 ],
		[ "A few times a year?", 4 ],
		[ "Never", 8 ],
		[ "Don't Know", 9 ],
	]
	@@freq_windows_open_cold_mos_12mos_options = {
		:question => "29.              During the last 12 months, how often was at least one window open on a regular basis during the colder months?

Would you say…",
		:answers => FREQ3
	}
	@@freq_windows_open_warm_mos_12mos_options = {
		:question => "30.               During the last 12 months, how often was at least one window open on a regular basis during the warmer months?

Would you say….",
		:answers => FREQ3
	}
# 31
	@@used_electric_heat_12mos_options = {
		:question => "Electric heat   ",
		:answers  => YNDK
	}
	@@used_kerosene_heat_12mos_options = {
		:question => "Kerosene heat   ",
		:answers  => YNDK
	}
	@@used_radiator_12mos_options = {
		:question => "Radiator or steam heat    ",
		:answers  => YNDK
	}
	@@used_gas_heat_12mos_options = {
		:question => "Gas heat (including gas fireplace)   ",
		:answers  => YNDK
	}
	@@used_wood_burning_stove_12mos_options = {
		:question => "Wood-burning Stove    ",
		:answers  => YNDK
	}
	@@freq_used_heat_12mos_options = {
		:question => " 31a. How often did you use during the past 12 months?  ",
		:answers => OSRN
	}
	@@used_wood_fireplace_12mos_options = {
		:question => "   Wood-burning Fireplace?       ",
		:answers  => YNDK
	}
	@@freq_burned_wood_12mos_options = {
		:question => "31b. How often did you use during the past 12 months?  ",
		:answers => OSRN
	}
	@@used_fireplace_insert_12mos_options = {
		:question => "31c.               Was an insert used in the fireplace? (An insert is a wood stove designed to fit into a conventional open fireplace and allows for clean efficient burning of wood.)",
		:answers  => YNDK
	}
# 32
	@@used_gas_stove_12mos_options = {
		:question => "1 = A gas stove/oven  ",
		:answers  => YNDK
	}
	@@used_gas_dryer_12mos_options = {
		:question => "2 = A gas clothes dryer       ",
		:answers  => YNDK
	}
	@@used_gas_water_heater_12mos_options = {
		:question => "3 = A gas water heater   ",
		:answers  => YNDK
	}
	@@used_other_gas_appliance_12mos_options = {
		:question => "8 = How about some other gas appliance ",
		:answers  => YNDK
	}
#	@@type_of_other_gas_appliance_options = YNDK
# 33
	@@painted_inside_home_options = {
		:question => "1 = Painting done indoors    ",
		:answers  => YNDK
	}
	@@carpeted_in_home_options = {
		:question => "2 = Carpeting",
		:answers  => YNDK
	}
	@@refloored_in_home_options = {
		:question => "3 = Reflooring",
		:answers  => YNDK
	}
	@@weather_proofed_home_options = {
		:question => "4 = Weather Proofing",
		:answers  => YNDK
	}
	@@replaced_home_windows_options = {
		:question => "5 = Window Replacement  ",
		:answers  => YNDK
	}
	@@roof_work_on_home_options = {
		:question => "6 = Roofing  ",
		:answers  => YNDK
	}
	@@construction_in_home_options = {
		:question => "7 = Construction",
		:answers  => YNDK
	}
	@@other_home_remodelling_options = {
		:question => "8 = Other: SPECIFY",
		:answers  => YNDK
	}
#	@@type_other_home_remodelling_options = YNDK
# 34
	@@regularly_smoked_indoors_options = {
		:question => "34.               During the time you have lived in this home, have you or anyone else regularly - that is once a week or more –    smoked cigarettes, pipes or cigars inside this home?",
		:answers  => YNDK
	}
	@@regularly_smoked_indoors_12mos_options = {
		:question => "34a.               During the last 12 months, have you or anyone else regularly - that is once a week or more – smoked cigarettes, pipes or cigars inside this home? ",
		:answers  => YNDK
	}
	@@regularly_smoked_outdoors_options = {
		:question => "35.               During the time you have lived in this home, have you or anyone who lives in this home  regularly smoked cigarettes, pipes or cigars outside this home (in the car, at work, yard, deck, etc.)?    ",
		:answers  => YNDK
	}
	@@regularly_smoked_outdoors_12mos_options = {
		:question => "35a.               During the last 12 months, have you or anyone else who lives in this home  regularly smoked  cigarettes, pipes or cigars outside this home?",
		:answers  => YNDK
	}
	@@used_smokeless_tobacco_12mos_options = {
		:question => "36.               During the last 12 months, have you or anyone else regularly - that is once a week or more – used smokeless tobacco products such as dipping or chewing tobacco in this home? ",
		:answers  => YNDK
	}
# 37
	QTY = [
		[ "0", 1 ],
		[ "1-2", 2 ],
		[ "3-5", 3 ],
		[ "More than 5", 4 ],
		[ "Don't Know", 9 ]
	]
	@@qty_of_stuffed_furniture_options = {
		:question => "37.               Not including mattresses, how many pieces of upholstered furniture do you have in your home (like padded or cushioned chairs, couches, or love seats)?",
		:answers  => QTY
	}
	@@qty_bought_after_2006_options = {
		:question => " 37a.              How many of the items were purchased after 2006?",
		:answers  => QTY
	}
	@@furniture_has_exposed_foam_options = {
		:question => "37b.              Does any of the upholstered furniture have exposed or crumbling foam?",
		:answers  => YNDK
	}
	@@home_has_carpets_options = {
		:question => "38.              Not including area rugs, are there any carpets in your home?",
		:answers  => YNDK
	}
# 38a
	@@percent_home_with_carpet_options = {
		:question => "38a.              Approximately what percentage of your home has carpet?",
		:answers  => [
			[ "Less than 25%", 1 ],
			[ "25% - 49%", 2 ],
			[ "50% - 74%", 3 ],
			[ "75% - 100%", 4 ],
			[ "Don’t know", 9 ]
		]
	}
	@@home_has_televisions_options = {
		:question => "39.               Do you have any televisions in your home?",
		:answers  => YNDK
	}
#	@@number_of_televisions_in_home_options = YNDK
	HOURS = [
		[ "less than one hour per day", 1 ],
		[ "1-2 hours per day", 2 ],
		[ "3-6 hours per day", 3 ],
		[ "More than 6 hours per day", 4 ],
		[ "Don't Know", 9 ],
	]
	@@avg_number_hours_tvs_used_options = {
		:question => "39b.               On average, how many hours per day is the television/are the televisions on in your home?",
		:answers  => HOURS
	}
	@@home_has_computers_options = {
		:question => "40.               Do you have any computers in your home?",
		:answers  => YNDK
	}
#	@@number_of_computers_in_home_options = YNDK
	@@avg_number_hours_computers_used_options = {
		:question => "40b.               On average, how many hours per day is the computer/are the computers in use in your home?",
		:answers  => HOURS
	}
#	@@additional_comments_options = YNDK

end
