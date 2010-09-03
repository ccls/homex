class Interview::SubjectsController < HxApplicationController

#	before_filter :may_view_subjects_required
	before_filter :may_view_required

	def index
		remember_or_recall_sort_order
		hx = Project.find_by_code('HomeExposures')
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		params[:projects] ||= {}
		params[:projects][hx.id] ||= {}
		params[:projects][hx.id][:chosen] = true 
#		@subjects = Subject.search(params)
		@subjects = SubjectSearch.new(params).subjects
#		@subjects = hx.subjects.search(params.merge(
#			#	interview outcome != complete
#			:interview_outcome => 'incomplete'
##			:is_chosen => true
#		))
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "subjects/index"
		end
	end

end
