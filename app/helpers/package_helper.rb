module PackageHelper

	def tracks_for(package)
		s = "<div id='tracks'>&nbsp;\n"	#	leave the &nbsp; so never empty
		package.tracks.each do |event|
			s << "<div class='track row'>\n"
			s << "<div class='name'>#{event.name}</div>\n"
			s << "<div class='location'>#{event.location}</div>\n"
			s << "<div class='time'>#{event.time}</div>\n"
			s << "</div><!-- class='track row' -->\n"
		end
		s << "</div><!-- id='tracks' -->\n"
	end

end
