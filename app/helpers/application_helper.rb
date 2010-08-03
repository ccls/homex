# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def home_exposure_main_menu
		s = "<div id='mainmenu'>\n"
		controller_name = controller.controller_name
		names = controller.class.name.split('::')

		#	TODO : subjects is always current with namespace changes

		l = [link_to( "Subjects", hx_subjects_path,
			:class => (%w(subjects addresses enrollments).include?(controller_name)  && names.length < 3 )?'current':nil)]

		l.push(link_to( "Interview", hx_interview_subjects_path,  
			:class => (names.include?('Interview'))?'current':nil))
		l.push(link_to( "Samples", hx_sample_subjects_path,
			:class => (names.include?('Sample'))?'current':nil))
		l.push(link_to( "Follow-Up", hx_followup_subjects_path,
			:class => (names.include?('Followup'))?'current':nil))
		s << l.join("\n")
		s << "\n</div><!-- mainmenu -->\n"
	end

	def se_check_boxes(se,attr)
		s = "<li>#{attr.to_s.capitalize}?<ul><li>\n"
		s << check_box_tag( "projects[#{se.id}][#{attr}][]", 'true',
				params.dig('projects',se.id.to_s,attr.to_s).true?,
				:id => "projects_#{se.id}_#{attr}_true" )
		s << label_tag( "projects_#{se.id}_#{attr}_true", "True" )
		s << "</li><li>\n"
		s << check_box_tag( "projects[#{se.id}][#{attr}][]", 'false',
				params.dig('projects',se.id.to_s,attr.to_s).false?,
				:id => "projects_#{se.id}_#{attr}_false" )
		s << label_tag( "projects_#{se.id}_#{attr}_false", "False" )
		s << "</li></ul></li>\n"
	end

end
