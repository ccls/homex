module HeSubjectsHelper

	#	&uarr; and &darr;
	def sort_link(column,text=nil)
		order = column.downcase.gsub(/\s+/,'_')
		dir = ( params[:dir] && params[:dir] == 'asc' ) ? 'desc' : 'asc'
		link_text = text||column
		classes = [order]
		if params[:order] && params[:order] == order
			classes.push('sorted')
			link_text << if dir == 'desc'
				"&nbsp;&darr;"
			else
				"&nbsp;&uarr;"
			end
		end
		s = "<div class='#{classes.join(' ')}'>"
		s << link_to(link_text,params.merge(:order => order,:dir => dir))
		s << "</div>"
		s
	end

end
