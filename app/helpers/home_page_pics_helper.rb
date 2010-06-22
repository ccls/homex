module HomePagePicsHelper

	def active_check_box(hpp)
		s = "<div class='active'>\n"
		# it is IMPORTANT, nay VITAL, to have the hidden false BEFORE the check_box for true 
		s << hidden_field_tag( "home_page_pics[#{hpp.id}][active]", false, :id => nil )
		s << "\n"
		s << check_box_tag( "home_page_pics[#{hpp.id}][active]", true, hpp.active )
		s << "\n"
		s << label_tag( "home_page_pics[#{hpp.id}][active]", "Active?" )
		s << "</div>\n"
	end

end
