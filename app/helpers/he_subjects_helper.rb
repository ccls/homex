module HeSubjectsHelper

	def sort_link(column,text=nil)
		klass = column.downcase.gsub(/\s+/,'_')
		dir = ( params[:dir] && params[:dir] == 'asc' ) ? 'desc' : 'asc'
		s = "<div class='#{klass}'>"
		s << link_to(text||column,params.merge(:order => klass,:dir => dir))
		s << "</div>"
		s
	end

end
