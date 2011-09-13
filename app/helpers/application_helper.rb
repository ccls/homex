# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def home_exposure_main_menu
		current = case controller.class.name.sub(/Controller$/,'')
			when *%w( 
					Addressings
					Contacts
					Enrollments
					Patients
					PhoneNumbers
					Subjects
					Events
				) then :study_subjects
			when *%w( 
					Interview::StudySubjects 
					Interviews
					HomeExposureResponses
				) then  :interview
#					ResponseSets
			when *%w( 
					Samples 
					Sample::StudySubjects 
					Packages
				) then :sample
			when *%w( 
					GiftCards
					Followup::GiftCards
					Followup::StudySubjects 
				) then :followup
			when *%w( 
					Guides 
					Users 
					Pages
				) then :admin
			else nil
		end

		s = "<div id='mainmenu'>\n"
		l = [link_to( "StudySubjects", study_subjects_path,
			:class => ((current == :study_subjects)?'current':nil))]
		l.push(link_to( "Interview", interview_study_subjects_path,  
			:class => ((current == :interview)?'current':nil)))
		l.push(link_to( "Samples", sample_study_subjects_path,
			:class => ((current == :sample)?'current':nil)))
		l.push(link_to( "Gift Cards", followup_study_subjects_path,
			:class => ((current == :followup)?'current':nil)))

#		l.push(link_to( "Admin", admin_path,
#			:class => ((current == :admin)?'current':nil))
#		) if current_user.try(:may_administrate?)

		s << l.join("\n")
		s << "\n</div><!-- mainmenu -->\n"
	end

	def administrator_menu()
		link_to( "Admin", admin_path )
	end

	def id_bar_for(object,&block)
		#	In development, the app will forget
		require_dependency 'study_subject.rb'
		require_dependency 'gift_card.rb'
		case object
			when StudySubject  then study_subject_id_bar(object,&block)
			when GiftCard then gift_card_id_bar(object,&block)
			else nil
		end
	end

	def sub_menu_for(object)
		#	In development, the app will forget
		require_dependency 'study_subject.rb'
		require_dependency 'interview.rb'
#		if object.is_a?(StudySubject)
		case object
			when StudySubject   then study_subject_sub_menu(object)
			when Interview then interview_sub_menu(object)
			else nil
		end
	end

	def followup_sub_menu
		current = case controller.class.name.sub(/Controller$/,'')
			when *%w( Followup::StudySubjects )  then :study_subjects
			when *%w( Followup::GiftCards ) then :gift_cards
			else nil
		end
		content_for :main do
			s = "<div id='submenu'>\n"
			l=[link_to( 'manage by subject', followup_study_subjects_path,
				:class => ((current == :study_subjects)?'current':nil)
			)]
			l.push(link_to( 'manage by cards',
				followup_gift_cards_path,
				:class => ((current == :gift_cards)?'current':nil)))
			s << l.join("\n")
			s << "\n</div><!-- submenu -->\n"
		end
	end

	def interview_sub_menu(interview)
		current = case controller.class.name.sub(/Controller$/,'')
			when *%w( Interviews ) then :general
			when *%w( ResponseSets ) then :edit
			else nil
		end
		content_for :main do
			s = "<div id='submenu'>\n"
#			l=[link_to( 'schedule interview', study_subject_path(interview.study_subject),
			l=[link_to( 'general', interview_path(interview),
				:class => ((current == :general)?'current':nil)
			)]
			l.push(link_to( 'edit/view interview',
				study_subject_home_exposure_response_path(interview.study_subject),
				:class => ((current == :edit)?'current':nil)))
#			l.push(link_to( 'edit/view interview', 
#				study_subject_response_sets_path(interview.study_subject),
#				:class => ((current == :edit)?'current':nil)))
			s << l.join("\n")
			s << "\n</div><!-- submenu -->\n"
		end
	end

	def study_subject_sub_menu(study_subject)
		current = case controller.class.name.sub(/Controller$/,'')
			when *%w( StudySubjects ) then :general
			when *%w( Patients ) then :hospital
			when *%w( Addresses Addressings Contacts PhoneNumbers 
				) then :contact
			when *%w( Enrollments ) then :eligibility
			when *%w( Events ) then :events
			else nil
		end
		content_for :main do
			s = "<div id='submenu'>\n"
			l=[link_to( 'general', study_subject_path(study_subject),
				:class => ((current == :general)?'current':nil)
			)]
			l.push(link_to( 'hospital', study_subject_patient_path(study_subject),
				:class => ((current == :hospital)?'current':nil)
			)) #if study_subject.is_case?
			l.push(link_to( 'address/contact', study_subject_contacts_path(study_subject),
				:class => ((current == :contact)?'current':nil)))
			l.push(link_to( 'eligibility/enrollments', 
				study_subject_enrollments_path(study_subject),
				:class => ((current == :eligibility)?'current':nil)))
			l.push(link_to( 'events', 
				study_subject_events_path(study_subject),
				:class => ((current == :events)?'current':nil)))
			s << l.join("\n")
			s << "\n</div><!-- submenu -->\n"
		end
	end

#	def se_check_boxes(se,attr)
#		s = "<li>#{attr.to_s.capitalize}?<ul><li>\n"
#		s << check_box_tag( "projects[#{se.id}][#{attr}][]", 'true',
#				params.dig('projects',se.id.to_s,attr.to_s).true?,
#				:id => "projects_#{se.id}_#{attr}_true" )
#		s << label_tag( "projects_#{se.id}_#{attr}_true", "True" )
#		s << "</li><li>\n"
#		s << check_box_tag( "projects[#{se.id}][#{attr}][]", 'false',
#				params.dig('projects',se.id.to_s,attr.to_s).false?,
#				:id => "projects_#{se.id}_#{attr}_false" )
#		s << label_tag( "projects_#{se.id}_#{attr}_false", "False" )
#		s << "</li></ul></li>\n"
#	end

#	TODO this is also in simply_helpful so perhaps remove it here
#	def mdy(date)
#		( date.nil? )?'&nbsp;':date.strftime("%m/%d/%Y")
#	end
#
#	def y_n_dk(value)
#		case value
#			when 1   then 'Yes'
#			when 2   then 'No'
#			when 999 then "Don't Know"
#			else '&nbsp;'
#		end
#	end

end
