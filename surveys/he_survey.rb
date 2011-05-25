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


def _q_y_n_dk(title,options={})
	q     title, options.merge(:pick => :one)
	a_1   "1 = Yes",        :data_export_identifier => 1
	a_2   "2 = No",         :data_export_identifier => 2
	a_999 "9 = Don't know", :data_export_identifier => 999
end
alias _q_yndk _q_y_n_dk

def _q_osrn(title,options={})
	q   title, options.merge(:pick => :one)
	a_1 "1 = Often",     :data_export_identifier => 1
	a_2 "2 = Sometimes", :data_export_identifier => 2
	a_3 "3 = Rarely",    :data_export_identifier => 3
	a_4 "4 = Never",     :data_export_identifier => 4
end

def _q_five_times(title,options={})
	q   title, options.merge(:pick => :one)
	a_1 "1 = 5 or more time",     :data_export_identifier => 1
	a_2 "2 = Fewer than 5 times", :data_export_identifier => 2
end

def _q_freq_1(title,options={})
	q   title, options.merge(:pick => :one)
	a_1 "1 = Every day (or almost every day)", :data_export_identifier => 1
	a_2 "2 = 1-2 times per week",              :data_export_identifier => 2
	a_3 "3 = 1-2 times per month",             :data_export_identifier => 3
	a_4 "4 = less than one time per month",    :data_export_identifier => 4
	a_5 "5 = Never?",                          :data_export_identifier => 5
	a_9 "9 = Don't Know",                      :data_export_identifier => 999
end

def _q_freq_2(title,options={})
	q   title, options.merge(:pick => :one)
	a_1 "1 = Every day or almost everyday", :data_export_identifier => 1
	a_2 "2 = About once a week",            :data_export_identifier => 2
	a_3 "3 = A few times a month",          :data_export_identifier => 3
	a_4 "4 = A few times a year?",          :data_export_identifier => 4
	a_5 "5 = Never",                        :data_export_identifier => 5			#8
	a_9 "9 = Don't Know",                   :data_export_identifier => 999
end

def _q_quantity(title,options={})
	q   title, options.merge(:pick => :one)
	a_1 "1 = 0",           :data_export_identifier => 1
	a_2 "2 = 1-2",         :data_export_identifier => 2
	a_3 "3 = 3-5",         :data_export_identifier => 3
	a_4 "4 = More than 5", :data_export_identifier => 4
	a_9 "9 = Don't Know",  :data_export_identifier => 999
end

def _q_hours(title,options={})
	q   title, options.merge(:pick => :one)
	a_1 "1 = less than one hour per day", :data_export_identifier => 1
	a_2 "2 = 1-2 hours per day",          :data_export_identifier => 2
	a_3 "3 = 3-6 hours per day",          :data_export_identifier => 3
	a_4 "4 = More than 6 hours per day",  :data_export_identifier => 4
	a_9 "9 = Don't Know",                 :data_export_identifier => 999
end

survey "Home Exposure survey",
	:manual_numbering => true do

	section "Intro / Consent" do

		label "Interview Introduction"

		label "Indicate any responses to the checkbox items in the introduction of the Interview here."

		q "&nbsp;", :pick => :any, 
			:data_export_identifier => :consent_read_over_phone
		a "READ CONSENT OVER THE PHONE", :data_export_identifier => 1

		q "&nbsp;", :pick => :any, 
			:data_export_identifier => :respondent_requested_new_consent
		a "RESPONDENT REQUESTED ANOTHER LETTER/CONSENT", :data_export_identifier => 1

		q "&nbsp;", :pick => :any, 
			:data_export_identifier => :consent_reviewed_with_respondent
		a "CHECK HERE IF THE ELEMENTS OF CONSENT HAVE BEEN REVIEWED WITH THE RESPONDENT AND THE RESPONDENT HAS BEEN GIVEN AN OPPORTUNITY TO ASK QUESTIONS.", :data_export_identifier => 1

	end

  section "Basic questions" do

#		label "Before we start, I just want to remind you that everything you tell us is confidential, and you may refuse to answer any questions or stop the interview at any time."
		
		_q_yndk "Does your vacuum cleaner have a disposable bag?", 
			:number => 2,
			:data_export_identifier => :vacuum_has_disposable_bag
		
		q "In the last 12 months, on average, how often were the rugs and floors in your home usually vacuumed?  Would you say...",
			:number => 3,
			:pick => :one, 
			:data_export_identifier => :how_often_vacuumed_12mos
		a "1 = Less than once a month", :data_export_identifier => 1
		a "2 = 1-3 times a month",      :data_export_identifier => 2
		a "3 = Once a week",            :data_export_identifier => 3
		a "4 = More than once a week?", :data_export_identifier => 4
		a "9 = Don't know",             :data_export_identifier => 999
		
		_q_y_n_dk "In the last 12 months, did all of the people who lived in your home usually take off their shoes when entering the home?",
			:number => 4,
			:data_export_identifier => :shoes_usually_off_inside_12mos
		
		_q_y_n_dk "During the last 12 months, did you or anyone else in your home eat hamburger, steak, pork, chicken or other meat products?",
			:number => 5,
			:reference_identifier => '5',
			:data_export_identifier => :someone_ate_meat_12mos
		
		label "I am now going to ask you about different high temperature cooking methods you or other household members may have used to cook meat.",
			:custom_class => 'dependent',
			:number => 6
#			:custom_class => "question label dependent hidden"
#	dependent seems to be the class for color and indentation
#		dependency :rule => "A"
#		condition_A :q_5, "==", :a_1
	
		_q_osrn "Pan fry (very hot)", 
			:custom_class => 'dependent',
			:number => '6a',
			:data_export_identifier => :freq_pan_fried_meat_12mos
#			:custom_class => "question dependent hidden"
#		dependency :rule => "A"
#		condition_A :q_5, "==", :a_1
	
		_q_osrn "Deep fry", 
			:custom_class => 'dependent',
			:number => '6b',
			:data_export_identifier => :freq_deep_fried_meat_12mos
#		dependency :rule => "A"
#		condition_A :q_5, "==", :a_1
	
		_q_osrn "Oven broil", 
			:custom_class => 'dependent',
			:number => '6c',
			:data_export_identifier => :freq_oven_fried_meat_12mos
#		dependency :rule => "A"
#		condition_A :q_5, "==", :a_1
	
		_q_osrn "Grill or barbeque?",
			:custom_class => 'dependent',
			:number => '6d',
			:data_export_identifier => :freq_grilled_meat_outside_12mos
#		dependency :rule => "A"
#		condition_A :q_5, "==", :a_1
	
		_q_osrn "Other", 
			:custom_class => 'dependent',
			:number => '6e',
			:reference_identifier => '6e',
			:data_export_identifier => :freq_other_high_temp_cooking_12mos
#		dependency :rule => "A"
#		condition_A :q_5, "==", :a_1

		q_6f "Specify", 
			:custom_class => 'dependent',
			:data_export_identifier => :other_type_high_temp_cooking
		a_1 :string
#		dependency :rule => "A and (B or C or D)"
#		condition_A :q_5,  "==", :a_1
#		condition_B :q_6e, "==", :a_1
#		condition_C :q_6e, "==", :a_2
#		condition_D :q_6e, "==", :a_3

#	adding conditions causes the whole group to be dependent on them
#		dependency :rule => "A or B or C"
#		condition_A :q_6e, "==", :a_1
#		condition_B :q_6e, "==", :a_2
#		condition_C :q_6e, "==", :a_3
	
		q_7 "During the last 12 months, when you or other household members ate meat products, how well were they usually cooked on the outside? Would you say...",
			:custom_class => 'dependent',
			:number => 7,
			:pick => :one, 
			:data_export_identifier => :doneness_of_meat_exterior_12mos
		a "1 = Not browned",                  :data_export_identifier => 1
		a "2 = Lightly-browned",              :data_export_identifier => 2
		a "3 = Well-browned",                 :data_export_identifier => 3
		a "4 = Black or charred",             :data_export_identifier => 4
		a "5 = It varies (volunteered code)", :data_export_identifier => 5
		a "9 = Don't Know",                   :data_export_identifier => 999
#		dependency :rule => "A"
#		condition_A :q_5, "==", :a_1
	
	end

	section "Jobs" do

		label "We are interested in various jobs that anyone living in your home may have had in the past 12 months. I am going to read you a list of jobs. Please tell me if anyone living in your home, including yourself, had any of these jobs in the past 12 months.  How about...",
			:number => 8

		_q_y_n_dk "1 = Airplane Mechanic", 
			:data_export_identifier => :job_is_plane_mechanic_12mos

		_q_y_n_dk "2 = Artist / Art Teacher", 
			:data_export_identifier => :job_is_artist_12mos

		_q_y_n_dk "3 = Cleaner / Janitor", 
			:data_export_identifier => :job_is_janitor_12mos

		_q_y_n_dk "4 = Construction Worker / Carpenter", 
			:data_export_identifier => :job_is_construction_12mos

		_q_y_n_dk "5 = Dentist / Dental Worker", 
			:data_export_identifier => :job_is_dentist_12mos

		label "Did anyone have any of these jobs in the past 12 months?  How about..."

		_q_y_n_dk "6 = Electrician / Lineman / Cable puller", 
			:data_export_identifier => :job_is_electrician_12mos

		_q_y_n_dk "7 = Engineer/ Environmental Scientist", 
			:data_export_identifier => :job_is_engineer_12mos

		_q_y_n_dk "8 = Farmer / Farm or Ranch Worker", 
			:data_export_identifier => :job_is_farmer_12mos

		_q_y_n_dk "9 = Gardner / Groundskeeper / Landscaper / Nursery worker", 
			:data_export_identifier => :job_is_gardener_12mos

		_q_y_n_dk "10 = Laboratory worker / Lab ScienceTeacher", 
			:data_export_identifier => :job_is_lab_worker_12mos

		label "Did anyone have any of these jobs in the past 12 months?  How about..."

		_q_y_n_dk "11 = Manufacturing / Assembly / Industrial operations/ Product repair", 
			:data_export_identifier => :job_is_manufacturer_12mos

		_q_y_n_dk "12 = Mechanic-auto / truck / bus", 
			:data_export_identifier => :job_auto_mechanic_12mos

		_q_y_n_dk "13 = Medical Patient Care Worker", 
			:data_export_identifier => :job_is_patient_care_12mos

		_q_y_n_dk "14 = Packer - Agricultural", 
			:data_export_identifier => :job_is_agr_packer_12mos

		_q_y_n_dk "15 = Painter / Wallpaperer", 
			:data_export_identifier => :job_is_painter_12mos

		label "Did anyone have any of these jobs in the past 12 months?  How about..."

		_q_y_n_dk "16 = Pesticiding Handling / Production / Formulation or Mixing", 
			:data_export_identifier => :job_is_pesticides_12mos

		_q_y_n_dk "17 = Photographer / Framer / Photography Teacher", 
			:data_export_identifier => :job_is_photographer_12mos

		_q_y_n_dk "18 = Teacher-- Preschool to 5th Grade", 
			:data_export_identifier => :job_is_teacher_12mos

		_q_y_n_dk "19 = Welder / Joiner", 
			:data_export_identifier => :job_is_welder_12mos
	
	end

	section "Products" do
		label "Now I have some questions about products that you may have used in or around the home during the last 12 months."

		_q_y_n_dk "During the last 12 months, did you have a pet that was treated for fleas or ticks using shampoos, soaps, collars, sprays, dusts, powders, or skin applications?",
			:number => 9,
			:reference_identifier => '9',
			:data_export_identifier => :used_flea_control_12mos

		_q_five_times "How often during the past 12 months? Would you say...", 
			:number => '9a',
			:data_export_identifier => :freq_used_flea_control_12mos
		dependency :rule => "A"
		condition_A :q_9, "==", :a_1

		_q_y_n_dk "During the last 12 months, have you or anyone else in your home used ant, fly, or cockroach control products in or around the house?",
			:number => 10,
			:reference_identifier => '10',
			:data_export_identifier => :used_ant_control_12mos

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '10a',
			:data_export_identifier => :freq_ant_control_12mos
		dependency :rule => "A"
		condition_A :q_10, "==", :a_1



		_q_y_n_dk "During the last 12 months, have you or anyone else in your home used bee, wasp, or hornet control products in or around the house?",
			:number => 11,
			:reference_identifier => '11',
			:data_export_identifier => :used_bee_control_12mos

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '11a',
			:data_export_identifier => :freq_bee_control_12mos
		dependency :rule => "A"
		condition_A :q_11, "==", :a_1



		_q_y_n_dk "During the last 12 months, did you or anyone in your home use any products to control indoor plant insects or diseases?",
			:number => 12,
			:reference_identifier => '12',
			:data_export_identifier => :used_indoor_plant_prod_12mos

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '12a',
			:data_export_identifier  => :freq_indoor_plant_product_12mos
		dependency :rule => "A"
		condition_A :q_12, "==", :a_1



		_q_y_n_dk "During the last 12 months, did you or anyone in your home treat any other indoor insects or other types of pests?  Do not include products applied outside on your lawn, garden, or trees.",
			:number => 13,
			:reference_identifier => '13',
			:data_export_identifier => :used_other_indoor_product_12mos

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '13a',
			:data_export_identifier  => :freq_other_indoor_product_12mos
		dependency :rule => "A"
		condition_A :q_13, "==", :a_1


		_q_y_n_dk "During the last 12 months, have you or anyone else in your home used indoor foggers or bombs?",
			:number => 14,
			:reference_identifier => '14',
			:data_export_identifier => :used_indoor_foggers

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '14a',
			:data_export_identifier  => :freq_indoor_foggers_12mos
		dependency :rule => "A"
		condition_A :q_14, "==", :a_1



		_q_y_n_dk "During the last 12 months has a professional pest control person or exterminator applied products inside this dwelling?",
			:number => 15,
			:reference_identifier => '15',
			:data_export_identifier => :used_pro_pest_inside_12mos

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '15a',
			:data_export_identifier  => :freq_pro_pest_inside_12mos
		dependency :rule => "A"
		condition_A :q_15, "==", :a_1



		_q_y_n_dk "During the last 12 months, has a professional pest control person or exterminator applied products on the exterior or foundation of this dwelling?",
			:number => 16,
			:reference_identifier => '16',
			:data_export_identifier => :used_pro_pest_outside_12mos

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '16a',
			:data_export_identifier  => :freq_used_pro_pest_outside_12mos
		dependency :rule => "A"
		condition_A :q_16, "==", :a_1



		_q_y_n_dk "During the last 12 months, has a professional lawn or landscape service treated the lawn, garden, trees or other outdoor plants with products to control weeds, insects, or plant diseases?",
			:number => 17,
			:reference_identifier => '17',
			:data_export_identifier => :used_pro_lawn_service_12mos

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '17a',
			:data_export_identifier  => :freq_pro_lawn_service_12mos
		dependency :rule => "A"
		condition_A :q_17, "==", :a_1



		_q_y_n_dk "In the last 12 months, did you or anyone in your home treat the lawn, garden, trees, or other outdoor plants with products to control weeds, insects, or plant diseases?",
			:number => 18,
			:reference_identifier => '18',
			:data_export_identifier => :used_lawn_products_12mos

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '18a',
			:data_export_identifier  => :freq_lawn_products_12mos
		dependency :rule => "A"
		condition_A :q_18, "==", :a_1



		_q_y_n_dk "In the last 12 months, did you or anyone in your home use products to control slugs or snails?",
			:number => 19,
			:reference_identifier => '19',
			:data_export_identifier => :used_slug_control_12mos

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '19a',
			:data_export_identifier  => :freq_slug_control_12mos
		dependency :rule => "A"
		condition_A :q_19, "==", :a_1



		_q_y_n_dk "In the last 12 months, did you or anyone in your home use products, not including traps, to control rats, mice, gophers or moles?",
			:number => 20,
			:reference_identifier => '20',
			:data_export_identifier => :used_rat_control_12mos

		_q_five_times "How often during the past 12 months?  Would you say...", 
			:number => '20a',
			:data_export_identifier => :freq_rat_control_12mos
		dependency :rule => "A"
		condition_A :q_20, "==", :a_1



		_q_y_n_dk "In the last 12 months, have mothballs been used in your home?",
			:number => 21,
			:reference_identifier => '21',
			:data_export_identifier => :used_mothballs_12mos


		label "During the last 12 months, did the community spray for any of the following insects near your home?  How about ...",
			:number => 22


		_q_y_n_dk "Gypsy moths", 
			:number => '22a',
			:data_export_identifier => :cmty_sprayed_gypsy_moths_12mos

		_q_y_n_dk "Mediterranean fruit flies", 
			:number => '22b',
			:data_export_identifier => :cmty_sprayed_medflies_12mos

		_q_y_n_dk "Mosquitoes", 
			:number => '22c',
			:data_export_identifier => :cmty_sprayed_mosquitoes_12mos

		_q_y_n_dk "Glassy Winged Sharpshooter", 
			:number => '22d',
			:data_export_identifier => :cmty_sprayed_sharpshooters_12mos

		_q_y_n_dk "Light Brown Apple Moth", 
			:number => '22e',
			:data_export_identifier => :cmty_sprayed_apple_moths_12mos

		_q_y_n_dk "Some Other insect (specify)", 
			:number => '22f',
			:reference_identifier => '22f',
			:data_export_identifier => :cmty_sprayed_other_pest_12mos

		q_22g  "Other pest", 
			:data_export_identifier => :other_pest_community_sprayed
		a :string
		dependency :rule => "A"
		condition_A :q_22f, "==", :a_1

	end

	section "Home" do
		label "Now I have a few questions about your home."

		q_23 "Which of the following best describes your residence?",
			:number => 23,
			:pick => :one, 
			:data_export_identifier => :type_of_residence
		a_1 "1 = Single family residence", :data_export_identifier => 1
		a_2 "2 = Duplex / Townhouse",      :data_export_identifier => 2 
		a_3 "3 = Apartment / Condominium", :data_export_identifier => 3
		a_4 "4 = Mobile Home",             :data_export_identifier => 4
		a_5 "8 = Other (specify)",         :data_export_identifier => 8
		a   "9 = Don't Know",              :data_export_identifier => 999

		q_23other "Other", 
			:data_export_identifier => :other_type_of_residence
		a :string
		dependency :rule => "A"
		condition_A :q_23, "==", :a_5
	

		q_23a "How many floors are there in your residence?",
			:number => '23a',
			:pick => :one,
			:data_export_identifier => :number_of_floors_in_residence
		a :integer	#, :custom_renderer => :ccls_answers
#		a :string
		a "Don't know", :data_export_identifier => 999
		dependency :rule => "A or B"
		condition_A :q_23, "==", :a_1
		condition_B :q_23, "==", :a_2
		#	I don't think that the letters have to be different
		#	but for clarity, they are.
#		validation :rule => "C"
#		vcondition_C ">=", :integer_value => 1



		q_23b "How many stories are there in your building?",
			:number => '23b',
			:pick => :one,
			:data_export_identifier => :number_of_stories_in_building
		a :integer	#, :custom_renderer => :ccls_answers
#		a :string
		a "Don't know", :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_23, "==", :a_3

		#	I don't think that the letters have to be different
		#	but for clarity, they are.
#		validation :rule => "C"
#		vcondition_C ">=", :integer_value => 1


		q_24 "In what year was your home built? ",
			:number => 24,
			:pick => :one,
			:data_export_identifier => :year_home_built
		a :integer	#, :custom_renderer => :ccls_answers
#		a :string
		a "Don't know", :data_export_identifier => 999

		#	I don't think that the letters have to be different
		#	but for clarity, they are.
#		validation :rule => "C"
#		vcondition_C ">=", :integer_value => 1

		q_25 "We are interested in the approximate size of your living space. The living space is defined as all heated areas in the home or apartment that are suitable for year-round use.  About how many square feet is your residence?",
			:number => 25,
			:pick => :one,
			:data_export_identifier => :home_square_footage
		a :integer	#, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999

		q_26 "How many rooms are there in your residence, not including closets, crawl spaces, attics and basements?",
			:number => 26,
			:pick => :one,
			:data_export_identifier => :number_of_rooms_in_home
		a :integer	#, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999

		q_27 "Is your residence mostly constructed of?  ",
			:number => 27,
			:pick => :one, 
			:data_export_identifier => :home_constructed_of
		a "1 = Wood",                       :data_export_identifier => 1
		a "2 = Mason / Brick / Cement",     :data_export_identifier => 2
		a "3 = Pre-fabricated panels",      :data_export_identifier => 3
		a_3 "8 = Something Else (specify)", :data_export_identifier => 8
		a "9 = Don't Know",                 :data_export_identifier => 999

		q_27other "Other",
			:data_export_identifier => :other_home_material
		a :string
		dependency :rule => "A"
		condition_A :q_27, "==", :a_3
	

		_q_y_n_dk "Does this home have an attached garage?  (An attached garage has a door connecting directly to the house.)",
			:number => 28,
			:reference_identifier => '28',
			:data_export_identifier => :home_has_attached_garage

		_q_y_n_dk "Has there been a car or motorcycle parked in the attached garage during the past month?",
			:number => '28a',
			:reference_identifier => '28a',
			:data_export_identifier => :vehicle_in_garage_1mo
		dependency :rule => "A"
		condition_A :q_28, "==", :a_1

#		q_28b "How often was the car or motorcycle moved in and out of garage during the past month?  Would you say...",
#			:number => '28b',
#			:pick => :one, 
#			:data_export_identifier => :freq_in_out_garage_1mo
#		a "1 = Every day (or almost every day)", :data_export_identifier => 1
#		a "2 = 1-2 times per week",              :data_export_identifier => 2
#		a "3 = 1-2 times per month",             :data_export_identifier => 3
#		a "4 = less than one time per month",    :data_export_identifier => 4
#		a "5 = Never?",                          :data_export_identifier => 5
#		a "9 = Don't Know",                      :data_export_identifier => 999
#		dependency :rule => "A"
#		condition_A :q_28a, "==", :a_1



#	20110525 - noticed this naming inconsistency ...
#			:reference_identifier => '28a',
#	don't think that it caused any problems

		_q_freq_1 "How often was the car or motorcycle moved in and out of garage during the past month?  Would you say...",
			:reference_identifier => '28b',
			:number => '28b',
			:data_export_identifier => :freq_in_out_garage_1mo
		dependency :rule => "A"
		condition_A :q_28a, "==", :a_1


		_q_y_n_dk "Does this residence have any type of electric cooling system such as air conditioning? ",
			:number => 29,
			:reference_identifier => '29',
			:data_export_identifier => :home_has_electric_cooling


#		q_30 "During the last 12 months, how often was at least one window or door open on a regular basis during the colder months?  Would you say...",
#			:number => 30,
#			:pick => :one, 
#			:data_export_identifier => :freq_windows_open_cold_mos_12mos
#		a "Every day or almost everyday", :data_export_identifier => 1
#		a "About once a week",            :data_export_identifier => 2
#		a "A few times a month",          :data_export_identifier => 3
#		a "A few times a year?",          :data_export_identifier => 4
#		a "Never",                        :data_export_identifier => 8
#		a "Don't Know",                   :data_export_identifier => 999

		_q_freq_2 "During the last 12 months, how often was at least one window or door open on a regular basis during the colder months?  Would you say...",
			:number => 30,
			:reference_identifier => '30',
			:data_export_identifier => :freq_windows_open_cold_mos_12mos

#		q_31 "During the last 12 months, how often was at least one window or door open on a regular basis during the warmer months? Would you say...",
#			:number => 31,
#			:pick => :one, 
#			:data_export_identifier => :freq_windows_open_warm_mos_12mos
#		a "Every day or almost everyday", :data_export_identifier => 1
#		a "About once a week",            :data_export_identifier => 2
#		a "A few times a month",          :data_export_identifier => 3
#		a "A few times a year?",          :data_export_identifier => 4
#		a "Never",                        :data_export_identifier => 8
#		a "Don't Know",                   :data_export_identifier => 999

		_q_freq_2 "During the last 12 months, how often was at least one window or door open on a regular basis during the warmer months? Would you say...",
			:number => 31,
			:reference_identifier => '31',
			:data_export_identifier => :freq_windows_open_warm_mos_12mos

	end

	section "Heat" do
		label "Now I am going to ask you about different kinds of heat you may have used to heat your home in the last 12 months. CHECK ALL THAT APPLY.",
			:number => 32

		label "In the last 12 months, did you use..."

		_q_y_n_dk "Electric heat",
			:number => '32a',
			:data_export_identifier => :used_electric_heat_12mos

		_q_y_n_dk "Kerosene heat",
			:number => '32b',
			:data_export_identifier => :used_kerosene_heat_12mos

		_q_y_n_dk "Radiator or steam heat",
			:number => '32c',
			:data_export_identifier => :used_radiator_12mos

		_q_y_n_dk "Gas heat (including gas fireplace)",
			:number => '32d',
			:data_export_identifier => :used_gas_heat_12mos

		_q_y_n_dk "Wood-burning Stove",
			:number => '32e',
			:reference_identifier => '32e',
			:data_export_identifier => :used_wood_burning_stove_12mos

		_q_osrn "How often did you use wood-burning stove during the past 12 months?",
			:number => '32f',
			:data_export_identifier => :freq_used_wood_stove_12mos
		dependency :rule => "A"
		condition_A :q_32e, "==", :a_1


		_q_y_n_dk "Wood-burning Fireplace?",
			:number => '32g',
			:reference_identifier => '32g',
			:data_export_identifier => :used_wood_fireplace_12mos

		_q_osrn "How often did you use during the past 12 months?",
			:number => '32h',
			:reference_identifier => '32h',
			:data_export_identifier => :freq_used_wood_fireplace_12mos
		dependency :rule => "A"
		condition_A :q_32g, "==", :a_1

		_q_y_n_dk "Was an insert used in the fireplace in the last 12 months? (An insert is a wood stove designed to fit into a conventional open fireplace and allows for clean efficient burning of wood.)",
			:number => '32i',
			:data_export_identifier => :used_fireplace_insert_12mos
		dependency :rule => "A or B or C"
		condition_A :q_32h, "==", :a_1
		condition_B :q_32h, "==", :a_2
		condition_C :q_32h, "==", :a_3

	
	end

	section "Gas" do

		label "In the last 12 months, were any of the following gas appliances used in your home? How about....",
			:number => 33
	

		_q_y_n_dk "A gas stove/oven",
			:number => '33a',
			:data_export_identifier => :used_gas_stove_12mos

		_q_y_n_dk "A gas clothes dryer",
			:number => '33b',
			:data_export_identifier => :used_gas_dryer_12mos

		_q_y_n_dk "A gas water heater",
			:number => '33c',
			:data_export_identifier => :used_gas_water_heater_12mos

		_q_y_n_dk "How about some other gas appliance",
			:number => '33d',
			:reference_identifier => 'gas_other',
			:data_export_identifier => :used_other_gas_appliance_12mos

		q "Other (DO NOT INCLUDE GAS HEAT)",
			:data_export_identifier => :type_of_other_gas_appliance
		a :string
		dependency :rule => "A"
		condition_A :q_gas_other, "==", :a_1

	
	end

	section "Remodeling" do

		label "Please tell me if any of the following activities were done during the time you have lived in this home. How about.....",
			:number => 34

		_q_y_n_dk "Painting (indoors)",
			:number => '34a',
			:data_export_identifier => :painted_inside_home

		_q_y_n_dk "Carpeting",
			:number => '34b',
			:data_export_identifier => :carpeted_in_home

		_q_y_n_dk "Reflooring",
			:number => '34c',
			:data_export_identifier => :refloored_in_home

		_q_y_n_dk "Weather Proofing",
			:number => '34d',
			:data_export_identifier => :weather_proofed_home

		_q_y_n_dk "Window Replacement",
			:number => '34e',
			:data_export_identifier => :replaced_home_windows

		_q_y_n_dk "Roofing",
			:number => '34f',
			:data_export_identifier => :roof_work_on_home

		_q_y_n_dk "Construction",
			:number => '34g',
			:data_export_identifier => :construction_in_home

		_q_y_n_dk "Other: SPECIFY",
			:number => '34h',
			:reference_identifier => 'remodel_other',
			:data_export_identifier => :other_home_remodelling

		q "Other",
			:data_export_identifier => :type_other_home_remodelling
		a :string
		dependency :rule => "A"
		condition_A :q_remodel_other, "==", :a_1

	end

	section "Tobacco" do

		_q_y_n_dk "During the time you have lived in this home, have you or anyone else regularly - that is once a week or more - smoked cigarettes, pipes or cigars inside this home?",
			:number => 35,
			:reference_identifier => '35',
			:data_export_identifier => :regularly_smoked_indoors

		_q_y_n_dk "During the last 12 months, have you or anyone else regularly - that is once a week or more - smoked cigarettes, pipes or cigars inside this home?",
			:number => '35a',
			:data_export_identifier => :regularly_smoked_indoors_12mos
		dependency :rule => "A"
		condition_A :q_35, "==", :a_1


		_q_y_n_dk "During the time you have lived in this home, have you or anyone who lives in this home regularly smoked cigarettes, pipes or cigars outside this home (in the car, at work, yard, deck, etc.)?",
			:number => 36,
			:reference_identifier => '36',
			:data_export_identifier => :regularly_smoked_outdoors

		_q_y_n_dk "During the last 12 months, have you or anyone else who lives in this home regularly smoked cigarettes, pipes or cigars outside this home?",
			:number => '36a',
			:data_export_identifier => :regularly_smoked_outdoors_12mos
		dependency :rule => "A"
		condition_A :q_36, "==", :a_1

		_q_y_n_dk "During the last 12 months, have you or anyone else regularly - that is once a week or more - used smokeless tobacco products such as dipping or chewing tobacco in this home?",
			:number => 37,
			:data_export_identifier => :used_smokeless_tobacco_12mos

	end

	section "Furnishings" do

#		q_38 "Not including mattresses, how many pieces of upholstered furniture do you have in your home (like padded or cushioned chairs, couches, or love seats)?",
#			:number => 38,
#			:pick => :one, 
#			:data_export_identifier => :qty_of_upholstered_furniture
#		a_1 "0",           :data_export_identifier => 1
#		a_2 "1-2",         :data_export_identifier => 2
#		a_3 "3-5",         :data_export_identifier => 3
#		a_4 "More than 5", :data_export_identifier => 4
#		a_5 "Don't Know",  :data_export_identifier => 999

		_q_quantity "Not including mattresses, how many pieces of upholstered furniture do you have in your home (like padded or cushioned chairs, couches, or love seats)?",
			:number => 38,
			:reference_identifier => '38',
			:data_export_identifier => :qty_of_upholstered_furniture

#		q_38a "How many of the items were purchased after 2006?",
#			:number => '38a',
#			:pick => :one, 
#			:data_export_identifier => :qty_bought_after_2006
#		a "0",           :data_export_identifier => 1
#		a "1-2",         :data_export_identifier => 2
#		a "3-5",         :data_export_identifier => 3
#		a "More than 5", :data_export_identifier => 4
#		a "Don't Know",  :data_export_identifier => 999
#		dependency :rule => "A or B or C"
#		condition_A :q_38, "==", :a_2
#		condition_B :q_38, "==", :a_3
#		condition_C :q_38, "==", :a_4

		_q_quantity "How many of the items were purchased after 2006?",
			:number => '38a',
			:data_export_identifier => :qty_bought_after_2006
		dependency :rule => "A or B or C"
		condition_A :q_38, "==", :a_2
		condition_B :q_38, "==", :a_3
		condition_C :q_38, "==", :a_4

		_q_y_n_dk "Does any of the upholstered furniture have exposed or crumbling foam?",
			:number => '38b',
			:data_export_identifier => :furniture_has_exposed_foam
		dependency :rule => "A or B or C"
		condition_A :q_38, "==", :a_2
		condition_B :q_38, "==", :a_3
		condition_C :q_38, "==", :a_4

#	defining a dependency without a matching condition ends badly

		_q_y_n_dk "Not including area rugs, are there any carpets in your home?",
			:number => 39,
			:reference_identifier => '39',
			:data_export_identifier => :home_has_carpets

		q_39a "Approximately what percentage of your home has carpet?",
			:number => '39a',
			:pick => :one, 
			:data_export_identifier => :percent_home_with_carpet
		a "1 = Less than 25%", :data_export_identifier => 1
		a "2 = 25% - 49%",     :data_export_identifier => 2
		a "3 = 50% - 74%",     :data_export_identifier => 3
		a "4 = 75% - 100%",    :data_export_identifier => 4
		a "9 = Don't know",    :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_39, "==", :a_1



	end

	section "Electronics" do


		_q_y_n_dk "Do you have any televisions in your home?",
			:number => 40,
			:reference_identifier => '40',
			:data_export_identifier => :home_has_televisions

		q_40a "How many televisions are in your home?",
			:number => '40a',
			:pick => :one,
			:data_export_identifier => :number_of_televisions_in_home
		a :integer	#, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_40, "==", :a_1

#		q_40b "On average, how many hours per day is the television/are the televisions on in your home? IF MORE THAN ONE TV, please include the total hours each television is on.  Would you say...",
#			:number => '40b',
#			:pick => :one, 
#			:data_export_identifier => :avg_number_hours_tvs_used
#		a "less than one hour per day", :data_export_identifier => 1
#		a "1-2 hours per day",          :data_export_identifier => 2
#		a "3-6 hours per day",          :data_export_identifier => 3
#		a "More than 6 hours per day",  :data_export_identifier => 4
#		a "Don't Know",                 :data_export_identifier => 999
#		dependency :rule => "A"
#		condition_A :q_40, "==", :a_1

		_q_hours "On average, how many hours per day is the television/are the televisions on in your home? IF MORE THAN ONE TV, please include the total hours each television is on.  Would you say...",
			:number => '40b',
			:data_export_identifier => :avg_number_hours_tvs_used
		dependency :rule => "A"
		condition_A :q_40, "==", :a_1


		_q_y_n_dk "Do you have any computers in your home?",
			:number => 41,
			:reference_identifier => '41',
			:data_export_identifier => :home_has_computers

		q_41a "How many computers are in your home?",
			:pick => :one,
			:data_export_identifier => :number_of_computers_in_home
		a :integer	#, :custom_renderer => :ccls_answers
		a "Don't know", :data_export_identifier => 999
		dependency :rule => "A"
		condition_A :q_41, "==", :a_1


#		q_41b "On average, how many hours per day is the computer/are the computers in use in your home? IF MORE THAN ONE COMPUTER, please include the total hours each computer is in use. Would you say...",
#			:number => '41b',
#			:pick => :one, 
#			:data_export_identifier => :avg_number_hours_computers_used
#		a "less than one hour per day", :data_export_identifier => 1
#		a "1-2 hours per day",          :data_export_identifier => 2
#		a "3-6 hours per day",          :data_export_identifier => 3
#		a "More than 6 hours per day",  :data_export_identifier => 4
#		a "Don't Know",                 :data_export_identifier => 999
#		dependency :rule => "A"
#		condition_A :q_41, "==", :a_1

		_q_hours "On average, how many hours per day is the computer/are the computers in use in your home? IF MORE THAN ONE COMPUTER, please include the total hours each computer is in use. Would you say...",
			:number => '41b',
			:data_export_identifier => :avg_number_hours_computers_used
		dependency :rule => "A"
		condition_A :q_41, "==", :a_1

		q_42 "That’s all the questions I have for today.  Do you have any comments or additional information you would like to tell me?",
			:number => 42,
			:data_export_identifier => :additional_comments
		a :text

		label "Thank you very much for your time! We will be mailing you a collection kit with all the materials you will need to collect a dust sample from your vacuum cleaner and ship it to the study office. If possible, please do not change or empty your vacuum bag prior to the collection."

		label "Once we receive your dust sample, we will mail you a $25.00 Target gift card."

	end
end
