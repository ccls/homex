class HomeExposureResponse < ActiveRecord::Base
	belongs_to :subject

	validates_presence_of   :subject_id
	validates_uniqueness_of :subject_id
	validate                :valid_subject_id

	def self.q_column_names
		column_names - 
			%w( id subject_id childid created_at updated_at ) -
			%w( vacuum_bag_last_changed vacuum_used_outside_home )
	end

#	validates_numericality_of :number_of_floors_in_home,
#			:number_of_stories_in_home,
#			:home_square_footage,
#			:number_of_rooms_in_home,
#			:number_of_televisions_in_home,
#			:number_of_computers_in_home,
#			:year_home_built,
#		:greater_than_or_equal_to => 0
#	only validate when complete ????

#	YNDK = [
#		[ "Yes", 1 ],
#		[ "No", 2 ],
#		[ "Don't Know", 9 ]
#	]
#	OSRN = [
#		[ "Often", 1 ],
#		[ "Sometimes", 2 ],
#		[ "Rarely", 3 ],
#		[ "Never", 4 ]
#	]
#	FREQ1 = [
#		[ "5 or more time", 1 ],
#		[ "Fewer than 5 times", 2 ]
#	]
#	FREQ2 = [
#		[ "Every day (or almost every day)", 1 ],
#		[ "1-2 times per week", 2 ],
#		[ "1-2 times per month", 3 ],
#		[ "less than one time per month", 4 ],
#		[ "Never?", 5 ],
#		[ "Don't Know", 9 ]
#	]
#	FREQ3 = [
#		[ "Every day or almost everyday", 1 ],
#		[ "About once a week", 2 ],
#		[ "A few times a month", 3 ],
#		[ "A few times a year?", 4 ],
#		[ "Never", 8 ],
#		[ "Don't Know", 9 ],
#	]
#	QTY = [
#		[ "0", 1 ],
#		[ "1-2", 2 ],
#		[ "3-5", 3 ],
#		[ "More than 5", 4 ],
#		[ "Don't Know", 9 ]
#	]
#	HOURS = [
#		[ "less than one hour per day", 1 ],
#		[ "1-2 hours per day", 2 ],
#		[ "3-6 hours per day", 3 ],
#		[ "More than 6 hours per day", 4 ],
#		[ "Don't Know", 9 ],
#	]
#	MEAT = [
#		[ "Not browned", 1 ],
#		[ "Lightly-browned", 2 ],
#		[ "Well-browned", 3 ],
#		[ "Black or charred", 4 ],
#		[ "It varies (volunteered code)", 5 ],
#		[ "Don't Know", 9 ]
#	]
#	FREQ4 = [
#		[ "Less than once a month", 1 ],
#		[ "1-3 times a month", 2 ],
#		[ "Once a week", 3 ],
#		[ "More than once a week?", 4 ],
#		[ "Don't Know", 9 ]
#	] 
#	YN = [
#		[ "Yes", 1 ],
#		[ "No", 2 ]
#	]
#	RESIDENCE = [
#		[ "Single family residence", 1 ],
#		[ "Duplex / Townhouse", 2 ],
#		[ "Apartment / Condominium", 3 ],
#		[ "Mobile Home", 4 ],
#		[ "Other (specify)", 8 ],
#		[ "Don't Know", 9 ]
#	]
#	MATERIAL = [
#		[ "Wood", 1 ],
#		[ "Mason / Brick / Cement", 2 ],
#		[ "Pre-fabricated panels", 3 ],
#		[ "Something Else (specify)", 8 ],
#		[ "Don't Know", 9 ]
#	]
#	PERCENTAGES = [
#		[ "Less than 25%", 1 ],
#		[ "25% - 49%", 2 ],
#		[ "50% - 74%", 3 ],
#		[ "75% - 100%", 4 ],
#		[ "Don’t know", 9 ]
#	]
#
#
#	cattr_reader :questions_and_answers
#	@@questions_and_answers = [
#		{
#			:question => "Before we start I would like to remind you that everything you tell us is confidential.  You can refuse to answer any questions and you may stop the interview at any time."
#		},
#		{ :question => "1. Does your vacuum cleaner have a disposable bag?",
#			:answers  => YNDK,
#			:variable => :vacuum_has_disposable_bag 
#		},
#		{ 
#			:question => "2. In the last 12 months, on average, how often were the ru    gs and floors in this home usually vacuumed?  Would you say...?",
#			:answers  => FREQ4,
#			:variable => :how_often_vacuumed_12mos 
#		},
#		{
#		 :question => "3. In the last 12 months, did all of the people who lived in this home usually take off their shoes when entering the home?",
#			:answers  => YNDK, 
#			:variable => :shoes_usually_off_inside_12mos
#		},
#		{
#			:question => "4. During the last 12 months, did you or anyone else in your home eat hamburger, steak, pork, chicken or other meat products?",
#			:answers  => YNDK,
#			:variable => :someone_ate_meat_12mos
#		},
#		{
#			:question => "5. I am now going to ask you about different high temperature cooking methods you or other household members may have used to cook meat.  During the last 12 months, when you ate meat products, did you ...",
#			:answers => [
#				{
#					:question => "5a. Pan fry (very hot)",
#					:answers  => OSRN,
#					:variable => :freq_pan_fried_meat_12mos
#				},
#				{
#					:question => "5b. Deep fry",
#					:answers => OSRN,
#					:variable => :freq_deep_fried_meat_12mos
#				},
#				{
#					:question => "5c. Oven broil",
#					:answers => OSRN,
#					:variable => :freq_oven_fried_meat_12mos
#				},
#				{
#					:question => "5d. Grill or barbeque (outside)",
#					:answers => OSRN,
#					:variable => :freq_grilled_meat_outside_12mos
#				},
#				{
#					:question => "5e. Other:",
#					:answers => OSRN,
#					:variable => :freq_other_high_temp_cooking_12mos
#				},
#				{
#					:question => "Other Type",
#					:variable => :other_type_high_temp_cooking
#				}
#			]
#		},
#
#	
#		{
#			:question => "6. During the last 12 months, when you or other household members ate meat products, how well were they usually cooked on the outside? Would you say...",
#			:answers  => MEAT,
#			:variable => :doneness_of_meat_exterior_12mos
#		},
#		{
#			:question => "7. In the past 12 months, has anyone living in this home, including yourself, had one of the following jobs?",
#			:answers  => [
#				{
#					:question => "1 = Airplane Mechanic",
#					:answers  => YNDK,
#					:variable => :job_is_plane_mechanic_12mos
#				},
#				{
#					:question => "2 = Artist / Art Teacher",
#					:answers  => YNDK,
#					:variable => :job_is_artist_12mos
#				},
#				{
#					:question => "3 = Cleaner / Janitor",
#					:answers  => YNDK,
#					:variable => :job_is_janitor_12mos
#				},
#				{
#					:question => "4 = Construction Worker / Carpenter",
#					:answers  => YNDK,
#					:variable => :job_is_construction_12mos
#				},
#				{
#					:question => "5 = Dentist / Dental Worker",
#					:answers  => YNDK,
#					:variable => :job_is_dentist_12mos
#				},
#				{
#					:question => "6 = Electrician / Lineman / Cable puller",
#					:answers  => YNDK,
#					:variable => :job_is_electrician_12mos
#				},
#				{
#					:question => "7 = Engineer/ Environmental Scientist",
#					:answers  => YNDK,
#					:variable => :job_is_engineer_12mos
#				},
#				{
#					:question => "8 = Farmer / Farm or Ranch Worker",
#					:answers  => YNDK,
#					:variable => :job_is_farmer_12mos
#				},
#				{
#					:question => "9 = Gardner / Groundskeeper / Landscaper / Nursery worker",
#					:answers  => YNDK,
#					:variable => :job_is_gardener_12mos
#				},
#				{
#					:question => "10 = Laboratory worker / Lab ScienceTeacher",
#					:answers  => YNDK,
#					:variable => :job_is_lab_worker_12mos
#				},
#				{
#					:question => "11 = Manufacturing / Assembly / Industrial operations/ Product repair",
#					:answers  => YNDK,
#					:variable => :job_is_manufacturer_12mos
#				},
#				{
#					:question => "12 = Mechanic-auto / truck / bus",
#					:answers  => YNDK,
#					:variable => :job_auto_mechanic_12mos
#				},
#				{
#					:question => "13 = Medical Patient Care Worker",
#					:answers  => YNDK,
#					:variable => :job_is_patient_care_12mos
#				},
#				{
#					:question => "14 = Packer – Agricultural",
#					:answers  => YNDK,
#					:variable => :job_is_agr_packer_12mos
#				},
#				{
#					:question => "15 = Painter / Wallpaperer",
#					:answers  => YNDK,
#					:variable => :job_is_painter_12mos
#				},
#				{
#					:question => "16 = Pesticiding Handling / Production / Formulation or Mixing",
#					:answers  => YNDK,
#					:variable => :job_is_pesticides_12mos
#				},
#				{
#					:question => "17 = Photographer / Framer / Photography Teacher",
#					:answers  => YNDK,
#					:variable => :job_is_photographer_12mos
#				},
#				{
#					:question => "18 = Teacher-- Preschool to 5th Grade",
#					:answers  => YNDK,
#					:variable => :job_is_teacher_12mos
#				},
#				{
#					:question => "19 = Welder / Joiner",
#					:answers  => YNDK,
#					:variable => :job_is_welder_12mos
#				}
#			]
#		},
#
#		{
#			:question => "Now I have some questions about products that you may have used in or around the home during the last 12 months."
#		},
#
#		{
#			:question => "8. During the last 12 months, did you have a pet that was treated for fleas or ticks using shampoos, soaps, collars, sprays, dusts, powders, or skin applications?",
#			:answers  => YNDK,
#			:variable => :pet_treated_for_fleas_12mos
#		},
#		{
#			:question => "8a. How often during the past 12 months? Would you say...",
#			:answers  => FREQ1,
#			:variable => :freq_pet_treated_for_fleas_12mos
#		},
#		{
#			:question => "9. During the last 12 months, have you or anyone else in your home used ant, fly, or cockroach control products in or around the house?",
#			:answers  => YNDK,
#			:variable => :used_ant_control_12mos
#		},
#		{
#			:question => "9a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_ant_control_12mos
#		},
#		{
#			:question => "10. During the last 12 months, have you or anyone else in your home used bee, wasp, or hornet control products in or around the house?",
#			:answers  => YNDK,
#			:variable => :used_bee_control_12mos
#		},
#		{
#			:question => "10a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_bee_control_12mos
#		},
#		{
#			:question => "11. During the last 12 months, did you or anyone in your home use any products to control indoor plant insects or diseases?",
#			:answers  => YNDK,
#			:variable => :used_indoor_plant_prod_12mos
#		},
#		{
#			:question => "11a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_indoor_plant_product_12mos
#		},
#		{
#			:question => "12. During the last 12 months, did you or anyone in your home treat any other indoor insects or other types of pests?  Do not include products applied outside on your lawn, garden, or trees.",
#			:answers  => YNDK,
#			:variable => :treated_other_indoor_pest_12mos
#		},
#		{
#			:question => "12a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_other_indoor_pest_12mos
#		},
#		{
#			:question => "13. During the last 12 months, have you or anyone else in your home used indoor foggers or bombs?",
#			:answers  => YNDK,
#			:variable => :used_indoor_foggers
#		},
#		{
#			:question => "13a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_indoor_foggers_12mos
#		},
#		{
#			:question => "14. During the last 12 months has a professional pest control person or exterminator applied products inside this dwelling?",
#			:answers  => YNDK,
#			:variable => :used_pro_pest_inside_12mos
#		},
#		{
#			:question => "14a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_pro_pest_inside_12mos
#		},
#		{
#			:question => "15. During the last 12 months, has a professional pest control person or exterminator applied products on the exterior or foundation of this dwelling?",
#			:answers  => YNDK,
#			:variable => :used_pro_pest_outside_12mos
#		},
#		{
#			:question => "15a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_used_pro_pest_outside_12mos
#		},
#		{
#			:question => "16. During the last 12 months, has a professional lawn or landscape service treated the lawn, garden, trees or other outdoor plants with products to control weeds, insects, or plant diseases?",
#			:answers  => YNDK,
#			:variable => :used_pro_lawn_service_12mos
#		},
#		{
#			:question => "16a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_pro_lawn_service_12mos
#		},
#		{
#			:question => "17. In the last 12 months, did you or anyone in your home treat the lawn, garden, trees, or other outdoor plants with products to control weeds, insects, or plant diseases?",
#			:answers  => YNDK,
#			:variable => :used_lawn_products_12mos
#		},
#		{
#			:question => "17a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_lawn_products_12mos
#		},
#		{
#			:question => "18. In the last 12 months, did you or anyone in your home use products to control slugs or snails?",
#			:answers  => YNDK,
#			:variable => :used_slug_control_12mos
#		},
#		{
#			:question => "18a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_slug_control_12mos
#		},
#		{
#			:question => "19. Not including traps, in the last 12 months, did you or anyone in your home use products to control rats, mice, gophers or moles?",
#			:answers  => YNDK,
#			:variable => :used_rat_control_12mos
#		},
#		{
#			:question => "19a. How often during the past 12 months?  Would you say...",
#			:answers => FREQ1,
#			:variable => :freq_rat_control_12mos
#		},
#		{
#			:question => "20. In the last 12 months, have mothballs been used in your home?",
#			:answers  => YNDK,
#			:variable => :used_mothballs_12mos
#		},
#
#		{
#			:question => "21. During the last 12 months, did the community spray for any of the following insects near your home?  How about...",
#			:answers => [
#				{
#					:question => "1 = Gypsy moths ",
#					:answers  => YNDK,
#					:variable => :cmty_sprayed_moths_12mos
#				},
#				{
#					:question => "2 = Mediterranean fruit flies      ",
#					:answers  => YNDK,
#					:variable => :cmty_sprayed_medflies_12mos
#				},
#				{
#					:question => "3 = Mosquitoes  ",
#					:answers  => YNDK,
#					:variable => :cmty_sprayed_mosquitoes_12mos
#				},
#				{
#					:question => "4 = Glassy Winged Sharpshooter  ",
#					:answers  => YNDK,
#					:variable => :cmty_sprayed_sharpshooter_12mos
#				},
#				{
#					:question => "5 = Light Brown Apple Moth",
#					:answers  => YNDK,
#					:variable => :cmty_sprayed_moth_12mos
#				},
#				{
#					:question => "8 = Some Other insect   (specify)",
#					:answers  => YNDK,
#					:variable => :cmty_sprayed_other_pest_12mos
#				},
#				{
#					:question => "Other pest",
#					:variable => :other_pest_community_sprayed
#				}
#			]
#		},
#
#
#
#		{
#			:question => "Now I have a few questions about your home."
#		},
#
#
#
#
#		{
#			:question => "22. Which of the following best describes this residence? ",
#			:answers  => RESIDENCE,
#			:variable => :type_of_residence
#		},
#		{
#			:question => "Other",
#			:variable => :other_type_of_residence
#		},
#		{
#			:question => "22a. How many floors are there in your residence?",
#			:variable => :number_of_floors_in_home
#		},
#		{
#			:question => "22b. How many stories are there in your building?",
#			:variable => :number_of_stories_in_home
#		},
#		{
#			:question => "23. In what year was your home built? ",
#			:variable => :year_home_built
#		},
#		{
#			:question => "24. We are interested in the approximate size of your living space. The living space is defined as all heated areas in the home or apartment that are suitable for year-round use.  About how many square feet is your residence?",
#			:variable => :home_square_footage
#		},
#		{
#			:question => "25. How many rooms are there in your residence, excluding closets, crawl spaces, attics and basements?",
#			:variable => :number_of_rooms_in_home
#		},
#		{
#			:question => "26. Is your residence mostly constructed of?  ",
#			:answers  => MATERIAL,
#			:variable => :home_constructed_of
#		},
#		{
#			:question => "Other",
#			:variable => :other_home_material
#		},
#		{
#			:question => "27. Does this home have an attached garage?  (An attached garage has a door connecting directly to the house.)",
#			:answers  => YN,
#			:variable => :home_has_attached_garage
#		},
#		{
#			:question => "27a. Has there been a car or motorcycle parked in the attached garage during the past month?",
#			:answers  => YN,
#			:variable => :vehicle_in_garage_1mo
#		},
#		{
#			:question => "27b. How often was the car or motorcycle moved in and out of garage during the past month?  Would you say...",
#			:answers => FREQ2,
#			:variable => :freq_in_out_garage_1mo
#		},
#		{
#			:question => "28. Does this residence have any type of electric cooling system such as air conditioning? ",
#			:answers  => YN,
#			:variable => :home_has_electric_cooling
#		},
#		{
#			:question => "29. During the last 12 months, how often was at least one window open on a regular basis during the colder months?  Would you say...",
#			:answers => FREQ3,
#			:variable => :freq_windows_open_cold_mos_12mos
#		},
#		{
#			:question => "30. During the last 12 months, how often was at least one window open on a regular basis during the warmer months?  Would you say….",
#			:answers => FREQ3,
#			:variable => :freq_windows_open_warm_mos_12mos
#		},
#
#
#
#		{
#			:question => "31. Now I am going to ask you about different kinds of heat you may have used to heat your home in  the last 12 months. CHECK ALL THAT APPLY."
#		},
#		{
#			:question => "In the last 12 months, did you use..."
#		},
#
#		{
#			:question => "Electric heat",
#			:answers  => YNDK,
#			:variable => :used_electric_heat_12mos
#		},
#		{
#			:question => "Kerosene heat",
#			:answers  => YNDK,
#			:variable => :used_kerosene_heat_12mos
#		},
#		{
#			:question => "Radiator or steam heat",
#			:answers  => YNDK,
#			:variable => :used_radiator_12mos
#		},
#		{
#			:question => "Gas heat (including gas fireplace)",
#			:answers  => YNDK,
#			:variable => :used_gas_heat_12mos
#		},
#		{
#			:question => "Wood-burning Stove",
#			:answers  => YNDK,
#			:variable => :used_wood_burning_stove_12mos
#		},
#		{
#			:question => "31a. How often did you use during the past 12 months?",
#			:answers => OSRN,
#			:variable => :freq_used_heat_12mos
#		},
#		{
#			:question => "Wood-burning Fireplace?",
#			:answers  => YNDK,
#			:variable => :used_wood_fireplace_12mos
#		},
#		{
#			:question => "31b. How often did you use during the past 12 months?",
#			:answers => OSRN,
#			:variable => :freq_burned_wood_12mos
#		},
#		{
#			:question => "31c. Was an insert used in the fireplace? (An insert is a wood stove designed to fit into a conventional open fireplace and allows for clean efficient burning of wood.)",
#			:answers  => YNDK,
#			:variable => :used_fireplace_insert_12mos
#		},
#		{
#			:question => "1 = A gas stove/oven",
#			:answers  => YNDK,
#			:variable => :used_gas_stove_12mos
#		},
#		{
#			:question => "2 = A gas clothes dryer",
#			:answers  => YNDK,
#			:variable => :used_gas_dryer_12mos
#		},
#		{
#			:question => "3 = A gas water heater",
#			:answers  => YNDK,
#			:variable => :used_gas_water_heater_12mos
#		},
#		{
#			:question => "8 = How about some other gas appliance",
#			:answers  => YNDK,
#			:variable => :used_other_gas_appliance_12mos
#		},
#		{
#			:question => "Other (DO NOT INCLUDE GAS HEAT)",
#			:variable => :type_of_other_gas_appliance
#		},
#		{
#			:question => "1 = Painting done indoors",
#			:answers  => YNDK,
#			:variable => :painted_inside_home
#		},
#		{
#			:question => "2 = Carpeting",
#			:answers  => YNDK,
#			:variable => :carpeted_in_home
#		},
#		{
#			:question => "3 = Reflooring",
#			:answers  => YNDK,
#			:variable => :refloored_in_home
#		},
#		{
#			:question => "4 = Weather Proofing",
#			:answers  => YNDK,
#			:variable => :weather_proofed_home
#		},
#		{
#			:question => "5 = Window Replacement",
#			:answers  => YNDK,
#			:variable => :replaced_home_windows
#		},
#		{
#			:question => "6 = Roofing",
#			:answers  => YNDK,
#			:variable => :roof_work_on_home
#		},
#		{
#			:question => "7 = Construction",
#			:answers  => YNDK,
#			:variable => :construction_in_home
#		},
#		{
#			:question => "8 = Other: SPECIFY",
#			:answers  => YNDK,
#			:variable => :other_home_remodelling
#		},
#		{
#			:question => "Other",
#			:variable => :type_other_home_remodelling
#		},
#		{
#			:question => "34. During the time you have lived in this home, have you or anyone else regularly - that is once a week or more –    smoked cigarettes, pipes or cigars inside this home?",
#			:answers  => YNDK,
#			:variable => :regularly_smoked_indoors
#		},
#		{
#			:question => "34a. During the last 12 months, have you or anyone else regularly - that is once a week or more – smoked cigarettes, pipes or cigars inside this home?",
#			:answers  => YNDK,
#			:variable => :regularly_smoked_indoors_12mos
#		},
#		{
#			:question => "35. During the time you have lived in this home, have you or anyone who lives in this home  regularly smoked cigarettes, pipes or cigars outside this home (in the car, at work, yard, deck, etc.)?",
#			:answers  => YNDK,
#			:variable => :regularly_smoked_outdoors
#		},
#		{
#			:question => "35a. During the last 12 months, have you or anyone else who lives in this home  regularly smoked  cigarettes, pipes or cigars outside this home?",
#			:answers  => YNDK,
#			:variable => :regularly_smoked_outdoors_12mos
#		},
#		{
#			:question => "36. During the last 12 months, have you or anyone else regularly - that is once a week or more – used smokeless tobacco products such as dipping or chewing tobacco in this home?",
#			:answers  => YNDK,
#			:variable => :used_smokeless_tobacco_12mos
#		},
#		{
#			:question => "37. Not including mattresses, how many pieces of upholstered furniture do you have in your home (like padded or cushioned chairs, couches, or love seats)?",
#			:answers  => QTY,
#			:variable => :qty_of_stuffed_furniture
#		},
#		{
#			:question => "37a. How many of the items were purchased after 2006?",
#			:answers  => QTY,
#			:variable => :qty_bought_after_2006
#		},
#		{
#			:question => "37b. Does any of the upholstered furniture have exposed or crumbling foam?",
#			:answers  => YNDK,
#			:variable => :furniture_has_exposed_foam
#		},
#		{
#			:question => "38. Not including area rugs, are there any carpets in your home?",
#			:answers  => YNDK,
#			:variable => :home_has_carpets
#		},
#		{
#			:question => "38a. Approximately what percentage of your home has carpet?",
#			:answers  => PERCENTAGES,
#			:variable => :percent_home_with_carpet
#		},
#		{
#			:question => "39. Do you have any televisions in your home?",
#			:answers  => YNDK,
#			:variable => :home_has_televisions
#		},
#		{
#			:question => "39a. How many televisions are in your home?",
#			:variable => :number_of_televisions_in_home
#		},
#		{
#			:question => "39b. On average, how many hours per day is the television/are the televisions on in your home?",
#			:answers  => HOURS,
#			:variable => :avg_number_hours_tvs_used
#		},
#		{
#			:question => "40. Do you have any computers in your home?",
#			:answers  => YNDK,
#			:variable => :home_has_computers
#		},
#		{
#			:question => "40a. How many computers are in your home?",
#			:variable => :number_of_computers_in_home
#		},
#		{
#			:question => "40b. On average, how many hours per day is the computer/are the computers in use in your home?",
#			:answers  => HOURS,
#			:variable => :avg_number_hours_computers_used
#		},
#		{
#			:question => "41. Do you have any comments or additional information you would like to tell me?",
#			:variable => :additional_comments
#		}
#	]

protected

	def valid_subject_id
		errors.add(:subject_id, "is invalid") unless Subject.exists?(subject_id)
	end

end
