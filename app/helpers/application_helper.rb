# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	#	This creates a button that looks like a submit button
	#	but is just a javascript controlled link.
	def button_link_to( title, url )
		s =  "<button class='link' type='button'>"
		s << "<span class='href' style='display:none;'>"
		s << url_for(url)
		s << "</span>"
		s << title
		s << "</button>"
		s
	end

end
