# Surveys, sections, questions, groups, and answers all 
#		take the following reference arguments
#
# :reference_identifier   # usually from paper
# :data_export_identifier # data export
# :common_namespace       # maping to a common vocab
# :common_identifier      # maping to a common vocab
#
#	Use the :data_export_identified key to store chosen
#		variable names for questions and values for answers.
#

survey "Home Exposure survey" do

  section "Basic questions" do

		label "Before we start I would like to remind you that everything you tell us is confidential.  You can refuse to answer any questions and you may stop the interview at any time."
		
		q "Does your vacuum cleaner have a disposable bag?", 
			:pick => :one, 
			:data_export_identifier => :vacuum_has_disposable_bag
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9
		
		q "In the last 12 months, on average, how often were the rugs and floors in this home usually vacuumed?  Would you say...", 
			:pick => :one, 
			:data_export_identifier => :how_often_vacuumed_12mos
		a "Less than once a month", :data_export_identifier => 1
		a "1-3 times a month",      :data_export_identifier => 2
		a "Once a week",            :data_export_identifier => 3
		a "More than once a week?", :data_export_identifier => 4
		a "Don’t know",             :data_export_identifier => 9
		
		q "In the last 12 months, did all of the people who lived in this home usually take off their shoes when entering the home?", 
			:pick => :one, 
			:data_export_identifier => :shoes_usually_off_inside_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9
		
		q_4 "During the last 12 months, did you or anyone else in your home eat hamburger, steak, pork, chicken or other meat products?", 
			:pick => :one, 
			:data_export_identifier => :someone_ate_meat_12mos
		a_1 "Yes",        :data_export_identifier => 1
		a_2 "No",         :data_export_identifier => 2
		a_3 "Don’t know", :data_export_identifier => 9
		
		label "I am now going to ask you about different high temperature cooking methods you or other household members may have used to cook meat.  During the last 12 months, when you ate meat products, did you ..." 
		dependency :rule => "A"
		condition_A :q_4, "==", :a_1
	
		q_5a "Pan fry (very hot)", 
			:pick => :one, 
			:data_export_identifier => :freq_pan_fried_meat_12mos
		a "Often",     :data_export_identifier => 1
		a "Sometimes", :data_export_identifier => 2
		a "Rarely",    :data_export_identifier => 3
		a "Never",     :data_export_identifier => 4
		dependency :rule => "A"
		condition_A :q_4, "==", :a_1
	
		q_5b "Deep fry", 
			:pick => :one, 
			:data_export_identifier => :freq_deep_fried_meat_12mos
		a "Often",     :data_export_identifier => 1
		a "Sometimes", :data_export_identifier => 2
		a "Rarely",    :data_export_identifier => 3
		a "Never",     :data_export_identifier => 4
		dependency :rule => "A"
		condition_A :q_4, "==", :a_1
	
		q_5c "Oven broil", 
			:pick => :one, 
			:data_export_identifier => :freq_oven_fried_meat_12mos
		a "Often",     :data_export_identifier => 1
		a "Sometimes", :data_export_identifier => 2
		a "Rarely",    :data_export_identifier => 3
		a "Never",     :data_export_identifier => 4
		dependency :rule => "A"
		condition_A :q_4, "==", :a_1
	
		q_5d "Grill or barbeque (outside)", 
			:pick => :one, 
			:data_export_identifier => :freq_grilled_meat_outside_12mos
		a "Often",     :data_export_identifier => 1
		a "Sometimes", :data_export_identifier => 2
		a "Rarely",    :data_export_identifier => 3
		a "Never",     :data_export_identifier => 4
		dependency :rule => "A"
		condition_A :q_4, "==", :a_1
	
		q_5e "Other", 
			:pick => :one, 
			:data_export_identifier => :freq_other_high_temp_cooking_12mos
		a_1 "Often",     :data_export_identifier => 1
		a_2 "Sometimes", :data_export_identifier => 2
		a_3 "Rarely",    :data_export_identifier => 3
		a_4 "Never",     :data_export_identifier => 4
		dependency :rule => "A"
		condition_A :q_4, "==", :a_1

		q_5f "Specify", 
			:data_export_identifier => :other_type_high_temp_cooking
		a_1 :string
		dependency :rule => "A and (B or C or D)"
		condition_A :q_4,  "==", :a_1
		condition_B :q_5e, "==", :a_1
		condition_C :q_5e, "==", :a_2
		condition_D :q_5e, "==", :a_3

#	adding conditions causes the whole group to be dependent on them
#		dependency :rule => "A or B or C"
#		condition_A :q_5e, "==", :a_1
#		condition_B :q_5e, "==", :a_2
#		condition_C :q_5e, "==", :a_3
	
		q_6 "During the last 12 months, when you or other household members ate meat products, how well were they usually cooked on the outside? Would you say...", 
			:pick => :one, 
			:data_export_identifier => :doneness_of_meat_exterior_12mos
		a "Not browned",                  :data_export_identifier => 1
		a "Lightly-browned",              :data_export_identifier => 2
		a "Well-browned",                 :data_export_identifier => 3
		a "Black or charred",             :data_export_identifier => 4
		a "It varies (volunteered code)", :data_export_identifier => 5
		a "Don't Know",                   :data_export_identifier => 9
		dependency :rule => "A"
		condition_A :q_4, "==", :a_1
	
	end

	section "Jobs in the past 12 months" do

		label "In the past 12 months, has anyone living in this home, including yourself, had one of the following jobs?" 

		q_7a "1 = Airplane Mechanic", 
			:pick => :one, 
			:data_export_identifier => :job_is_plane_mechanic_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "2 = Artist / Art Teacher", 
			:pick => :one, 
			:data_export_identifier => :job_is_artist_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "3 = Cleaner / Janitor", 
			:pick => :one, 
			:data_export_identifier => :job_is_janitor_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "4 = Construction Worker / Carpenter", 
			:pick => :one, 
			:data_export_identifier => :job_is_construction_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "5 = Dentist / Dental Worker", 
			:pick => :one, 
			:data_export_identifier => :job_is_dentist_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "6 = Electrician / Lineman / Cable puller", 
			:pick => :one, 
			:data_export_identifier => :job_is_electrician_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "7 = Engineer/ Environmental Scientist", 
			:pick => :one, 
			:data_export_identifier => :job_is_engineer_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "8 = Farmer / Farm or Ranch Worker", 
			:pick => :one, 
			:data_export_identifier => :job_is_farmer_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "9 = Gardner / Groundskeeper / Landscaper / Nursery worker", 
			:pick => :one, 
			:data_export_identifier => :job_is_gardener_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "10 = Laboratory worker / Lab ScienceTeacher", 
			:pick => :one, 
			:data_export_identifier => :job_is_lab_worker_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "11 = Manufacturing / Assembly / Industrial operations/ Product repair", 
			:pick => :one, 
			:data_export_identifier => :job_is_manufacturer_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "12 = Mechanic-auto / truck / bus", 
			:pick => :one, 
			:data_export_identifier => :job_auto_mechanic_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "13 = Medical Patient Care Worker", 
			:pick => :one, 
			:data_export_identifier => :job_is_patient_care_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "14 = Packer – Agricultural", 
			:pick => :one, 
			:data_export_identifier => :job_is_agr_packer_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "15 = Painter / Wallpaperer", 
			:pick => :one, 
			:data_export_identifier => :job_is_painter_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "16 = Pesticiding Handling / Production / Formulation or Mixing", 
			:pick => :one, 
			:data_export_identifier => :job_is_pesticides_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "17 = Photographer / Framer / Photography Teacher", 
			:pick => :one, 
			:data_export_identifier => :job_is_photographer_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "18 = Teacher-- Preschool to 5th Grade", 
			:pick => :one, 
			:data_export_identifier => :job_is_teacher_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		question "19 = Welder / Joiner", 
			:pick => :one, 
			:data_export_identifier => :job_is_welder_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9
	
	end

	section "Products" do
		label "Now I have some questions about products that you may have used in or around the home during the last 12 months."

		q_8 "8. During the last 12 months, did you have a pet that was treated for fleas or ticks using shampoos, soaps, collars, sprays, dusts, powders, or skin applications?", 
			:pick => :one, 
			:data_export_identifier => :pet_treated_for_fleas_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9

		q_8a "8a. How often during the past 12 months? Would you say...", 
			:pick => :one, 
			:data_export_identifier => :freq_pet_treated_for_fleas_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_8, "==", :a_1

		q_9 "9. During the last 12 months, have you or anyone else in your home used ant, fly, or cockroach control products in or around the house?", 
			:pick => :one, 
			:data_export_identifier => :used_ant_control_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9



		q_9a "9a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier => :freq_ant_control_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_9, "==", :a_1



		q_10 "10. During the last 12 months, have you or anyone else in your home used bee, wasp, or hornet control products in or around the house?", 
			:pick => :one, 
			:data_export_identifier => :used_bee_control_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9



		q_10a "10a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier => :freq_bee_control_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_10, "==", :a_1



		q_11 "11. During the last 12 months, did you or anyone in your home use any products to control indoor plant insects or diseases?", 
			:pick => :one, 
			:data_export_identifier => :used_indoor_plant_prod_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9




		q_11a "11a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier  => :freq_indoor_plant_product_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_11, "==", :a_1



		q_12 "12. During the last 12 months, did you or anyone in your home treat any other indoor insects or other types of pests?  Do not include products applied outside on your lawn, garden, or trees.", 
			:pick => :one, 
			:data_export_identifier => :treated_other_indoor_pest_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9



		q_12a "12a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier  => :freq_other_indoor_pest_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_12, "==", :a_1


		q_13 "13. During the last 12 months, have you or anyone else in your home used indoor foggers or bombs?", 
			:pick => :one, 
			:data_export_identifier => :used_indoor_foggers
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_13a "13a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier  => :freq_indoor_foggers_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_13, "==", :a_1



		q_14 "14. During the last 12 months has a professional pest control person or exterminator applied products inside this dwelling?", 
			:pick => :one, 
			:data_export_identifier => :used_pro_pest_inside_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_14a "14a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier  => :freq_pro_pest_inside_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_14, "==", :a_1



		q_15 "15. During the last 12 months, has a professional pest control person or exterminator applied products on the exterior or foundation of this dwelling?", 
			:pick => :one, 
			:data_export_identifier => :used_pro_pest_outside_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9



		q_15a "15a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier  => :freq_used_pro_pest_outside_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_15, "==", :a_1



		q_16 "16. During the last 12 months, has a professional lawn or landscape service treated the lawn, garden, trees or other outdoor plants with products to control weeds, insects, or plant diseases?", 
			:pick => :one, 
			:data_export_identifier => :used_pro_lawn_service_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_16a "16a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier  => :freq_pro_lawn_service_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_16, "==", :a_1



		q_17 "17. In the last 12 months, did you or anyone in your home treat the lawn, garden, trees, or other outdoor plants with products to control weeds, insects, or plant diseases?", 
			:pick => :one, 
			:data_export_identifier => :used_lawn_products_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_17a "17a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier  => :freq_lawn_products_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_17, "==", :a_1



		q_18 "18. In the last 12 months, did you or anyone in your home use products to control slugs or snails?", 
			:pick => :one, 
			:data_export_identifier => :used_slug_control_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_18 "18a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier  => :freq_slug_control_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_18, "==", :a_1



		q_19 "19. Not including traps, in the last 12 months, did you or anyone in your home use products to control rats, mice, gophers or moles?", 
			:pick => :one, 
			:data_export_identifier => :used_rat_control_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_19a "19a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier => :freq_rat_control_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_19, "==", :a_1



		q_20 "20. In the last 12 months, have mothballs been used in your home?", 
			:pick => :one, 
			:data_export_identifier => :used_mothballs_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9



		label "21. During the last 12 months, did the community spray for any of the following insects near your home?  How about..."


		q_21a "1 = Gypsy moths ", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_moths_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_21b "2 = Mediterranean fruit flies", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_medflies_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_21c "3 = Mosquitoes  ", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_mosquitoes_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_21d "4 = Glassy Winged Sharpshooter  ", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_sharpshooter_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_21e "5 = Light Brown Apple Moth", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_moth_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_21f "8 = Some Other insect   (specify)", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_other_pest_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 9


		q_21g  "Other pest", 
			:data_export_identifier => :other_pest_community_sprayed
		a :string

	end
end





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
#end



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
