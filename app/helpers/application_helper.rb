# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def home_exposure_main_menu
#		controller_name = controller.controller_name
#		names = controller.class.name.split('::')
		current = case controller.class.name.sub(/Controller$/,'')
			when *%w( Addressings
					Contacts
					Enrollments
					Patients
					PhoneNumbers
					Subjects
				) then :subjects
			when *%w( Interview::Subjects Interviews
				) then  :interview
			when *%w( Samples Sample::Subjects
				) then :sample
			when *%w( Followup::Subjects 
				) then :followup
			when *%w( Guides Users Pages
				) then :admin
		end

		s = "<div id='mainmenu'>\n"
		l = [link_to( "Subjects", subjects_path,
			:class => ((current == :subjects)?'current':nil))]
		l.push(link_to( "Interview", interview_subjects_path,  
			:class => ((current == :interview)?'current':nil)))
		l.push(link_to( "Samples", sample_subjects_path,
			:class => ((current == :sample)?'current':nil)))
		l.push(link_to( "Follow-Up", followup_subjects_path,
			:class => ((current == :followup)?'current':nil)))

		l.push(link_to( "Admin", admin_path,
			:class => ((current == :admin)?'current':nil))
		) if current_user.may_administrate?

		s << l.join("\n")
		s << "\n</div><!-- mainmenu -->\n"
	end

	def sub_menu_for(object)
		if object.is_a?(Subject)
			subject_sub_menu(object)
		end
	end

	def subject_sub_menu(subject)
		current = case controller.class.name.sub(/Controller$/,'')
			when *%w( Subjects ) then :general
			when *%w( Patients ) then :hospital
			when *%w( Addresses Addressings Contacts PhoneNumbers 
				) then :contact
			when *%w( Enrollments ) then :eligibility
		end
		content_for :main do
			s = "<div id='submenu'>\n"
			l=[link_to( 'general', subject_path(subject),
				:class => ((current == :general)?'current':nil)
			)]
			l.push(link_to( 'hospital', subject_patient_path(subject),
				:class => ((current == :hospital)?'current':nil)
			))
			l.push(link_to( 'address/contact', subject_contacts_path(subject),
				:class => ((current == :contact)?'current':nil)))
			l.push(link_to( 'eligibility/enrollments', 
				subject_enrollments_path(subject),
				:class => ((current == :eligibility)?'current':nil)))
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

	def mdy(date)
		( date.nil? )?'&nbsp;':date.strftime("%m/%d/%Y")
	end

	def y_n_dk(value)
		case value
			when 1   then 'Yes'
			when 2   then 'No'
			when 999 then "Don't Know"
			else '&nbsp;'
		end
	end

end
