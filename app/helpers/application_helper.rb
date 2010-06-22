# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def home_exposure_main_menu
		s = "<div id='mainmenu'>\n"
		controller_name = controller.controller_name
		l = [link_to( "Subjects", he_subjects_path,
			:class => (controller_name == 'subjects')?'current':nil)]
		l.push(link_to( "Enroll", he_enrolls_path,
			:class => (controller_name == 'enrolls')?'current':nil))
		l.push(link_to( "Interview", he_interviews_path,  
			:class => (controller_name == 'interviews')?'current':nil))
		l.push(link_to( "Samples", he_samples_path,
			:class => (controller_name == 'samples')?'current':nil))
		l.push(link_to( "Follow-Up", he_followups_path,
			:class => (controller_name == 'followups')?'current':nil))
		s << l.join("\n")
		s << "\n</div><!-- mainmenu -->\n"
	end

	def application_root_menu
		#<%# Page changes outside of ActionController go unnoticed %>
		#<%# Due to the variability of the menu, we can't really cache it %>
		#<%# cache 'page_menu' do %>
		roots = Page.roots
		count = roots.length
		count = ( count > 0 ) ? count : 1 
		width = ( 900 - count ) / count
		s = "<div id='rootmenu' class='main_width'>\n"
		roots.each do |page|
			s << link_to( page.menu(session[:locale]), page.path, 
				:style => "width: #{width}px",
				:class => ((page == @page.try(:root))?'current':nil))
			s << "\n"
		end
		s << "</div><!-- id='rootmenu' -->\n"
	end

	def application_sub_menu
		if @page && !@page.root.children.empty?
			s = "<div id='submenu' class='main_width'>\n"
			s << "<div id='current_root'>"
			s << @page.root.menu(session[:locale])
			s << "</div>\n"
			s << "<div id='children'>\n"
			@page.root.children.each do |child|
				s << "<span class='child#{(@page==child)?" current_child":""}'>"
				s << link_to( child.menu(session[:locale]), child.path )
				s << "</span>\n"
			end
			s << "</div><!-- id='children'  -->\n"
			s << "</div><!-- id='submenu'  -->\n"
		end
	end

	def application_home_page_pic
		if @page && @page.is_home? && !@hpp.nil?
			s = "<div id='home_page_pic' class='main_width'>\n"
			s << image_tag( @hpp.image.url(:full) )
			s << "\n</div><!-- id='home_page_pic'  -->\n"
		end
	end

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
		classes = ['link']
		classes << options[:class]
		s =  "<button class='#{classes.flatten.join(' ')}' type='button'>"
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
