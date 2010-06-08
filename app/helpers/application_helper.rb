# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper	#:nodoc:

	#	This creates a button that looks like a submit button
	#	but is just a javascript controlled link.
	#	I don't like it.
	def button_link_to( title, url, options={} )
#		id = "id='#{options[:id]}'" unless options[:id].blank?
#		klass = if options[:class].blank?
#			"class='link'"
#		else
#			"class='#{options[:class]}'"
#		end
#		s =  "<button #{id} #{klass} type='button'>"
		s =  "<button class='link' type='button'>"
		s << "<span class='href' style='display:none;'>"
		s << url_for(url)
		s << "</span>"
		s << title
		s << "</button>"
		s
	end

	#	Created this to create form styled buttons to use
	#	for the common 'cancel' feature. Unfortunately, it is
	#	invalid HTML to have a form inside of a form.  So
	#	this isn't as useful as initially hoped.
	def form_link_to( title, url, options={} )
		s =  "<form class='link_to' action='#{url}' method='get'>"
		s << submit_tag(title, :name => nil )
		s << "</form>"
	end

	def se_check_boxes(se,attr)
		s = "<li>#{attr.to_s.capitalize}?<ul><li>\n"
		s << check_box_tag( "study_events[#{se.id}][#{attr}][]", 'true',
				params.dig('study_events',se.id.to_s,attr.to_s).true?,
				:id => "study_events_#{se.id}_#{attr}_true" )
		s << label_tag( "study_events_#{se.id}_#{attr}_true", "True" )
		s << "</li><li>\n"
		s << check_box_tag( "study_events[#{se.id}][#{attr}][]", 'false',
				params.dig('study_events',se.id.to_s,attr.to_s).false?,
				:id => "study_events_#{se.id}_#{attr}_false" )
		s << label_tag( "study_events_#{se.id}_#{attr}_false", "False" )
		s << "</li></ul></li>\n"
	end

end
