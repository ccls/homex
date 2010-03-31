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
		a "Don’t know", :data_export_identifier => 999

		
		q "In the last 12 months, on average, how often were the rugs and floors in this home usually vacuumed?  Would you say...", 
			:pick => :one, 
			:data_export_identifier => :how_often_vacuumed_12mos
		a "Less than once a month", :data_export_identifier => 1
		a "1-3 times a month",      :data_export_identifier => 2
		a "Once a week",            :data_export_identifier => 3
		a "More than once a week?", :data_export_identifier => 4
		a "Don’t know",             :data_export_identifier => 999
		
		q "In the last 12 months, did all of the people who lived in this home usually take off their shoes when entering the home?", 
			:pick => :one, 
			:data_export_identifier => :shoes_usually_off_inside_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999
		
		q_4 "During the last 12 months, did you or anyone else in your home eat hamburger, steak, pork, chicken or other meat products?", 
			:pick => :one, 
			:data_export_identifier => :someone_ate_meat_12mos
		a_1 "Yes",        :data_export_identifier => 1
		a_2 "No",         :data_export_identifier => 2
		a_3 "Don’t know", :data_export_identifier => 999
		
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
		a "Don't Know",                   :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_4, "==", :a_1
	
	end

	section "Jobs" do

		label "In the past 12 months, has anyone living in this home, including yourself, had one of the following jobs?  How about ..."

		q_7a "1 = Airplane Mechanic", 
			:pick => :one, 
			:data_export_identifier => :job_is_plane_mechanic_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "2 = Artist / Art Teacher", 
			:pick => :one, 
			:data_export_identifier => :job_is_artist_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "3 = Cleaner / Janitor", 
			:pick => :one, 
			:data_export_identifier => :job_is_janitor_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "4 = Construction Worker / Carpenter", 
			:pick => :one, 
			:data_export_identifier => :job_is_construction_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "5 = Dentist / Dental Worker", 
			:pick => :one, 
			:data_export_identifier => :job_is_dentist_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "6 = Electrician / Lineman / Cable puller", 
			:pick => :one, 
			:data_export_identifier => :job_is_electrician_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "7 = Engineer/ Environmental Scientist", 
			:pick => :one, 
			:data_export_identifier => :job_is_engineer_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "8 = Farmer / Farm or Ranch Worker", 
			:pick => :one, 
			:data_export_identifier => :job_is_farmer_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "9 = Gardner / Groundskeeper / Landscaper / Nursery worker", 
			:pick => :one, 
			:data_export_identifier => :job_is_gardener_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "10 = Laboratory worker / Lab ScienceTeacher", 
			:pick => :one, 
			:data_export_identifier => :job_is_lab_worker_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "11 = Manufacturing / Assembly / Industrial operations/ Product repair", 
			:pick => :one, 
			:data_export_identifier => :job_is_manufacturer_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "12 = Mechanic-auto / truck / bus", 
			:pick => :one, 
			:data_export_identifier => :job_auto_mechanic_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "13 = Medical Patient Care Worker", 
			:pick => :one, 
			:data_export_identifier => :job_is_patient_care_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "14 = Packer – Agricultural", 
			:pick => :one, 
			:data_export_identifier => :job_is_agr_packer_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "15 = Painter / Wallpaperer", 
			:pick => :one, 
			:data_export_identifier => :job_is_painter_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "16 = Pesticiding Handling / Production / Formulation or Mixing", 
			:pick => :one, 
			:data_export_identifier => :job_is_pesticides_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "17 = Photographer / Framer / Photography Teacher", 
			:pick => :one, 
			:data_export_identifier => :job_is_photographer_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "18 = Teacher-- Preschool to 5th Grade", 
			:pick => :one, 
			:data_export_identifier => :job_is_teacher_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		question "19 = Welder / Joiner", 
			:pick => :one, 
			:data_export_identifier => :job_is_welder_12mos
		a "Yes",        :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999
	
	end

	section "Products" do
		label "Now I have some questions about products that you may have used in or around the home during the last 12 months."

		q_8 "8. During the last 12 months, did you have a pet that was treated for fleas or ticks using shampoos, soaps, collars, sprays, dusts, powders, or skin applications?", 
			:pick => :one, 
			:data_export_identifier => :used_flea_control_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_8a "8a. How often during the past 12 months? Would you say...", 
			:pick => :one, 
			:data_export_identifier => :freq_used_flea_control_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_8, "==", :a_1

		q_9 "9. During the last 12 months, have you or anyone else in your home used ant, fly, or cockroach control products in or around the house?", 
			:pick => :one, 
			:data_export_identifier => :used_ant_control_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999



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
		a "Don’t know", :data_export_identifier => 999



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
		a "Don’t know", :data_export_identifier => 999




		q_11a "11a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier  => :freq_indoor_plant_product_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_11, "==", :a_1



		q_12 "12. During the last 12 months, did you or anyone in your home treat any other indoor insects or other types of pests?  Do not include products applied outside on your lawn, garden, or trees.", 
			:pick => :one, 
			:data_export_identifier => :used_other_indoor_product_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999


		q_12a "12a. How often during the past 12 months?  Would you say...", 
			:pick => :one, 
			:data_export_identifier  => :freq_other_indoor_product_12mos
		a "5 or more time",     :data_export_identifier => 1
		a "Fewer than 5 times", :data_export_identifier => 2
		dependency :rule => "A"
		condition_A :q_12, "==", :a_1


		q_13 "13. During the last 12 months, have you or anyone else in your home used indoor foggers or bombs?", 
			:pick => :one, 
			:data_export_identifier => :used_indoor_foggers
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999


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
		a "Don’t know", :data_export_identifier => 999


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
		a "Don’t know", :data_export_identifier => 999



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
		a "Don’t know", :data_export_identifier => 999


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
		a "Don’t know", :data_export_identifier => 999


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
		a "Don’t know", :data_export_identifier => 999


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
		a "Don’t know", :data_export_identifier => 999


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
		a "Don’t know", :data_export_identifier => 999



		label "21. During the last 12 months, did the community spray for any of the following insects near your home?  How about..."


		q_21a "1 = Gypsy moths ", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_gypsy_moths_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999


		q_21b "2 = Mediterranean fruit flies", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_medflies_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999


		q_21c "3 = Mosquitoes  ", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_mosquitoes_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999


		q_21d "4 = Glassy Winged Sharpshooter  ", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_sharpshooters_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999


		q_21e "5 = Light Brown Apple Moth", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_apple_moths_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999


		q_21f "8 = Some Other insect   (specify)", 
			:pick => :one, 
			:data_export_identifier => :cmty_sprayed_other_pest_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_21g  "Other pest", 
			:data_export_identifier => :other_pest_community_sprayed
		a :string
		dependency :rule => "A"
		condition_A :q_21f, "==", :a_1

	end

	section "Home" do
		label "Now I have a few questions about your home."

		q_22 "22. Which of the following best describes this residence? ",
			:pick => :one, :data_export_identifier => :type_of_residence
		a_1 "Single family residence", :data_export_identifier => 1
		a_2 "Duplex / Townhouse",      :data_export_identifier => 2 
		a_3 "Apartment / Condominium", :data_export_identifier => 3
		a_4 "Mobile Home",             :data_export_identifier => 4
		a_5 "Other (specify)",         :data_export_identifier => 8
		a "Don't Know",                :data_export_identifier => 999

		q_22other "Other", 
			:data_export_identifier => :other_type_of_residence
		a :string
		dependency :rule => "A"
		condition_A :q_22, "==", :a_5
	

		q_22a "22a. How many floors are there in your residence?",
			:pick => :one,
			:data_export_identifier => :number_of_floors_in_residence
		a :integer, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999
		dependency :rule => "A or B"
		condition_A :q_22, "==", :a_1
		condition_B :q_22, "==", :a_2


		q_22b "22b. How many stories are there in your building?",
			:pick => :one,
			:data_export_identifier => :number_of_stories_in_building
		a :integer, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_22, "==", :a_3


		q_23 "23. In what year was your home built? ",
			:pick => :one,
			:data_export_identifier => :year_home_built
		a :integer, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999

		q_24 "24. We are interested in the approximate size of your living space. The living space is defined as all heated areas in the home or apartment that are suitable for year-round use.  About how many square feet is your residence?",
			:pick => :one,
			:data_export_identifier => :home_square_footage
		a :integer, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999

		q_25 "25. How many rooms are there in your residence, excluding closets, crawl spaces, attics and basements?",
			:pick => :one,
			:data_export_identifier => :number_of_rooms_in_home
		a :integer, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999

		q_26 "26. Is your residence mostly constructed of?  ",
			:pick => :one, 
			:data_export_identifier => :home_constructed_of
		a "Wood",                       :data_export_identifier => 1
		a "Mason / Brick / Cement",     :data_export_identifier => 2
		a "Pre-fabricated panels",      :data_export_identifier => 3
		a_3 "Something Else (specify)", :data_export_identifier => 8
		a "Don't Know",                 :data_export_identifier => 999

		q_26other "Other",
			:data_export_identifier => :other_home_material
		a :string
		dependency :rule => "A"
		condition_A :q_26, "==", :a_3
	

		q_27 "27. Does this home have an attached garage?  (An attached garage has a door connecting directly to the house.)",
			:pick => :one, 
			:data_export_identifier => :home_has_attached_garage
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_27a "27a. Has there been a car or motorcycle parked in the attached garage during the past month?",
			:pick => :one, 
			:data_export_identifier => :vehicle_in_garage_1mo
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_27, "==", :a_1

		q_27b "27b. How often was the car or motorcycle moved in and out of garage during the past month?  Would you say...",
			:pick => :one, 
			:data_export_identifier => :freq_in_out_garage_1mo
		a "Every day (or almost every day)", :data_export_identifier => 1
		a "1-2 times per week",              :data_export_identifier => 2
		a "1-2 times per month",             :data_export_identifier => 3
		a "less than one time per month",    :data_export_identifier => 4
		a "Never?",                          :data_export_identifier => 5
		a "Don't Know",                      :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_27a, "==", :a_1


		q_28 "28. Does this residence have any type of electric cooling system such as air conditioning? ",
			:pick => :one, 
			:data_export_identifier => :home_has_electric_cooling
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999


		q_29 "29. During the last 12 months, how often was at least one window open on a regular basis during the colder months?  Would you say...",
			:pick => :one, 
			:data_export_identifier => :freq_windows_open_cold_mos_12mos
		a "Every day or almost everyday", :data_export_identifier => 1
		a "About once a week",            :data_export_identifier => 2
		a "A few times a month",          :data_export_identifier => 3
		a "A few times a year?",          :data_export_identifier => 4
		a "Never",                        :data_export_identifier => 8
		a "Don't Know",                   :data_export_identifier => 999

		q_30 "30. During the last 12 months, how often was at least one window open on a regular basis during the warmer months?  Would you say...",
			:pick => :one, 
			:data_export_identifier => :freq_windows_open_warm_mos_12mos
		a "Every day or almost everyday", :data_export_identifier => 1
		a "About once a week",            :data_export_identifier => 2
		a "A few times a month",          :data_export_identifier => 3
		a "A few times a year?",          :data_export_identifier => 4
		a "Never",                        :data_export_identifier => 8
		a "Don't Know",                   :data_export_identifier => 999

	end

	section "Heat" do
		label "31. Now I am going to ask you about different kinds of heat you may have used to heat your home in  the last 12 months. CHECK ALL THAT APPLY."

		label "In the last 12 months, did you use..."

		q_31_heat_a "Electric heat",
			:pick => :one, 
			:data_export_identifier => :used_electric_heat_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_31_heat_b "Kerosene heat",
			:pick => :one, 
			:data_export_identifier => :used_kerosene_heat_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_31_heat_c "Radiator or steam heat",
			:pick => :one, :data_export_identifier => :used_radiator_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_31_heat_d "Gas heat (including gas fireplace)",
			:pick => :one, :data_export_identifier => :used_gas_heat_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_31_heat_e "Wood-burning Stove",
			:pick => :one, :data_export_identifier => :used_wood_burning_stove_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_31a "31a. How often did you use during the past 12 months?",
			:pick => :one, 
			:data_export_identifier => :freq_used_wood_stove_12mos
		a "Often",     :data_export_identifier => 1
		a "Sometimes", :data_export_identifier => 2
		a "Rarely",    :data_export_identifier => 3
		a "Never",     :data_export_identifier => 4
		dependency :rule => "A"
		condition_A :q_31_heat_e, "==", :a_1


		q_31_wood_burning "Wood-burning Fireplace?",
			:pick => :one, :data_export_identifier => :used_wood_fireplace_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_31b "31b. How often did you use during the past 12 months?",
			:pick => :one, 
			:data_export_identifier => :freq_used_wood_fireplace_12mos
		a_1 "Often",     :data_export_identifier => 1
		a_2 "Sometimes", :data_export_identifier => 2
		a_3 "Rarely",    :data_export_identifier => 3
		a "Never",       :data_export_identifier => 4
		dependency :rule => "A"
		condition_A :q_31_wood_burning, "==", :a_1

		q_31c "31c. Was an insert used in the fireplace in the last 12 months? (An insert is a wood stove designed to fit into a conventional open fireplace and allows for clean efficient burning of wood.)",
			:pick => :one, :data_export_identifier => :used_fireplace_insert_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999
		dependency :rule => "A or B or C"
		condition_A :q_31b, "==", :a_1
		condition_B :q_31b, "==", :a_2
		condition_C :q_31b, "==", :a_3

	
	end

	section "Gas" do

		label "32. In the last 12 months, were any of the following gas appliances used in your home? How about...."

		q "1 = A gas stove/oven",
			:pick => :one, :data_export_identifier => :used_gas_stove_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q "2 = A gas clothes dryer",
			:pick => :one, :data_export_identifier => :used_gas_dryer_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q "3 = A gas water heater",
			:pick => :one, :data_export_identifier => :used_gas_water_heater_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_gas_other "8 = How about some other gas appliance",
			:pick => :one, :data_export_identifier => :used_other_gas_appliance_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q "Other (DO NOT INCLUDE GAS HEAT)",
			:data_export_identifier => :type_of_other_gas_appliance
		a :string
		dependency :rule => "A"
		condition_A :q_gas_other, "==", :a_1

	
	end

	section "Remodelling" do

		label "33. Please tell me if any of the following activities were done during the time you have lived in this home. How about....."


		q "1 = Painting done indoors",
			:pick => :one, :data_export_identifier => :painted_inside_home
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q "2 = Carpeting",
			:pick => :one, :data_export_identifier => :carpeted_in_home
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q "3 = Reflooring",
			:pick => :one, :data_export_identifier => :refloored_in_home
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q "4 = Weather Proofing",
			:pick => :one, :data_export_identifier => :weather_proofed_home
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q "5 = Window Replacement",
			:pick => :one, :data_export_identifier => :replaced_home_windows
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q "6 = Roofing",
			:pick => :one, :data_export_identifier => :roof_work_on_home
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q "7 = Construction",
			:pick => :one, :data_export_identifier => :construction_in_home
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_remodel_other "8 = Other: SPECIFY",
			:pick => :one, :data_export_identifier => :other_home_remodelling
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q "Other",
			:data_export_identifier => :type_other_home_remodelling
		a :string
		dependency :rule => "A"
		condition_A :q_remodel_other, "==", :a_1

	
	end

	section "Tobacco" do

		q_34 "34. During the time you have lived in this home, have you or anyone else regularly - that is once a week or more –    smoked cigarettes, pipes or cigars inside this home?",
			:pick => :one, 
			:data_export_identifier => :regularly_smoked_indoors
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_34a "34a. During the last 12 months, have you or anyone else regularly - that is once a week or more – smoked cigarettes, pipes or cigars inside this home?",
			:pick => :one, 
			:data_export_identifier => :regularly_smoked_indoors_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_34, "==", :a_1


		q_35 "35. During the time you have lived in this home, have you or anyone who lives in this home  regularly smoked cigarettes, pipes or cigars outside this home (in the car, at work, yard, deck, etc.)?",
			:pick => :one, 
			:data_export_identifier => :regularly_smoked_outdoors
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_35a "35a. During the last 12 months, have you or anyone else who lives in this home  regularly smoked  cigarettes, pipes or cigars outside this home?",
			:pick => :one, 
			:data_export_identifier => :regularly_smoked_outdoors_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_35, "==", :a_1

		q_36 "36. During the last 12 months, have you or anyone else regularly - that is once a week or more – used smokeless tobacco products such as dipping or chewing tobacco in this home?",
			:pick => :one, 
			:data_export_identifier => :used_smokeless_tobacco_12mos
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

	end

	section "Furnishings" do

		q_37 "37. Not including mattresses, how many pieces of upholstered furniture do you have in your home (like padded or cushioned chairs, couches, or love seats)?",
			:pick => :one, 
			:data_export_identifier => :qty_of_upholstered_furniture
		a_1 "0",           :data_export_identifier => 1
		a_2 "1-2",         :data_export_identifier => 2
		a_3 "3-5",         :data_export_identifier => 3
		a_4 "More than 5", :data_export_identifier => 4
		a_5 "Don't Know",  :data_export_identifier => 999

		q_37a "37a. How many of the items were purchased after 2006?",
			:pick => :one, 
			:data_export_identifier => :qty_bought_after_2006
		a "0",           :data_export_identifier => 1
		a "1-2",         :data_export_identifier => 2
		a "3-5",         :data_export_identifier => 3
		a "More than 5", :data_export_identifier => 4
		a "Don't Know",  :data_export_identifier => 999
		dependency :rule => "A or B or C"
		condition_A :q_37, "==", :a_2
		condition_B :q_37, "==", :a_3
		condition_C :q_37, "==", :a_4

		q_37b "37b. Does any of the upholstered furniture have exposed or crumbling foam?",
			:pick => :one, 
			:data_export_identifier => :furniture_has_exposed_foam
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999
		dependency :rule => "A or B or C"
		condition_A :q_37, "==", :a_2
		condition_B :q_37, "==", :a_3
		condition_C :q_37, "==", :a_4

#	defining a dependency without a matching condition ends badly

		q_38 "38. Not including area rugs, are there any carpets in your home?",
			:pick => :one, 
			:data_export_identifier => :home_has_carpets
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_38a "38a. Approximately what percentage of your home has carpet?",
			:pick => :one, 
			:data_export_identifier => :percent_home_with_carpet
		a "Less than 25%", :data_export_identifier => 1
		a "25% - 49%",     :data_export_identifier => 2
		a "50% - 74%",     :data_export_identifier => 3
		a "75% - 100%",    :data_export_identifier => 4
		a "Don’t know",    :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_38, "==", :a_1



	end

	section "Electronics" do


		q_39 "39. Do you have any televisions in your home?",
			:pick => :one, 
			:data_export_identifier => :home_has_televisions
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_39a "39a. How many televisions are in your home?",
			:pick => :one,
			:data_export_identifier => :number_of_televisions_in_home
		a :integer, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_39, "==", :a_1

		q_39b "39b. On average, how many hours per day is the television/are the televisions on in your home?",
			:pick => :one, 
			:data_export_identifier => :avg_number_hours_tvs_used
		a "less than one hour per day", :data_export_identifier => 1
		a "1-2 hours per day",          :data_export_identifier => 2
		a "3-6 hours per day",          :data_export_identifier => 3
		a "More than 6 hours per day",  :data_export_identifier => 4
		a "Don't Know",                 :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_39, "==", :a_1


		q_40 "40. Do you have any computers in your home?",
			:pick => :one, 
			:data_export_identifier => :home_has_computers
		a_1 "Yes",      :data_export_identifier => 1
		a "No",         :data_export_identifier => 2
		a "Don’t know", :data_export_identifier => 999

		q_40a "40a. How many computers are in your home?",
			:pick => :one,
			:data_export_identifier => :number_of_computers_in_home
		a :integer, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_40, "==", :a_1


		q_40b "40b. On average, how many hours per day is the computer/are the computers in use in your home?",
			:pick => :one, 
			:data_export_identifier => :avg_number_hours_computers_used
		a "less than one hour per day", :data_export_identifier => 1
		a "1-2 hours per day",          :data_export_identifier => 2
		a "3-6 hours per day",          :data_export_identifier => 3
		a "More than 6 hours per day",  :data_export_identifier => 4
		a "Don't Know",                 :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_40, "==", :a_1

		q_41 "41. Do you have any comments or additional information you would like to tell me?",
			:data_export_identifier => :additional_comments
		a :text

		label "We will be mailing you a collection kit with all the materials you will need to collect a dust sample from your vacuum cleaner and ship it to the study office. If possible, please do not change or empty your vacuum bag prior to the collection."

		label "Once we receive your dust sample, we will mail you a $25.00 gift card."

	end
end
