module SubjectHelper

	def races_check_boxes
		if Race.count > 0
			s = "<fieldset id='races'>\n"
			s << "<legend>Races</legend>\n"
			s << "<ul>\n"
			Race.all.each do |race|
				s << "<li>"
				s << check_box_tag( 'races[]', race.name, 
						params['races'].try(:include?,race.name), 
						:id => dom_id(race))
				s << label_tag( dom_id(race), race.name )
				s << "</li>\n"
			end
			s << "</ul>\n"
			s << "</fieldset><!-- races -->\n"
		end # if Race.count > 0
	end

	def subject_types_check_boxes
		if SubjectType.count > 0
			s = "<fieldset id='types'>\n"
			s << "<legend>SubjectTypes</legend>\n"
			s << "<ul>\n"
			SubjectType.all.each do |type|
				s << "<li>"
				s << check_box_tag( 'types[]', type.name, 
					params['types'].try(:include?,type.name), 
					:id => dom_id(type))
				s << label_tag( dom_id(type), type.name )
				s << "</li>\n"
			end
			s << "</ul>\n"
			s << "</fieldset><!-- types -->\n"
		end # if SubjectType.count > 0
	end

	def dust_kit_radio_buttons
		s = "<fieldset id='dust_kit'>\n"
		s << "<legend>Dust Kit</legend>\n"
		s << "<ul>\n"
		s << "<li>"
		dk = params['dust_kit'] || ''
		s << radio_button_tag( 'dust_kit', 'ignore', ( dk == 'ignore' || dk.blank? ))
		s << label_tag( 'dust_kit_ignore', 'Ignore Dust Kit' )
		s << "</li>\n"
		s << "<li>"
		s << radio_button_tag( 'dust_kit', 'none', ( dk == 'none') )
		s << label_tag( 'dust_kit_none', 'No Dust Kit' )
		s << "</li>\n"
		s << "<li>"
		s << radio_button_tag( 'dust_kit', 'shipped', ( dk == 'shipped') )
		s << label_tag( 'dust_kit_shipped', 'Dust Kit Shipped' )
		s << "</li>\n"
		s << "<li>"
		s << radio_button_tag( 'dust_kit', 'delivered', ( dk == 'delivered') )
		s << label_tag( 'dust_kit_delivered', 'Dust Kit Delivered' )
		s << "</li>\n"
		s << "<li>"
		s << radio_button_tag( 'dust_kit', 'returned', ( dk == 'returned') )
		s << label_tag( 'dust_kit_returned', 'Dust Kit Returned' )
		s << "</li>\n"
		s << "<li>"
		s << radio_button_tag( 'dust_kit', 'received', ( dk == 'received') )
		s << label_tag( 'dust_kit_received', 'Dust Kit Received' )
		s << "</li>\n"
		s << "</ul>\n"
		s << "</fieldset><!-- dust_kit -->\n"
	end

	def study_event_stuff
		if StudyEvent.count > 0
			s = ''
			StudyEvent.all.each do |se|
				s << "<fieldset class='study_event'>\n"
				s << "<legend>#{se.description}</legend><ul>\n"
				s << se_check_boxes(se,:eligible)
				s << se_check_boxes(se,:chosen)
				s << se_check_boxes(se,:consented)
				s << se_check_boxes(se,:closed)
				s << se_check_boxes(se,:terminated)
				s << se_check_boxes(se,:completed)
				s << "<li>Refused</li>\n"
				s << "<li>Awaiting Letter</li>\n"
				s << "<li>Sent Letter</li>\n"
				s << "<li>Awaiting Interview</li>\n"
				s << "<li>Interviewed</li>\n"
				s << "</ul>\n"
				s << "</fieldset><!-- study_event -->\n"
			end
			s
		end	#	if StudyEvent.count > 0
	end

end
