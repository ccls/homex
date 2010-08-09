class Hx::Followup::SubjectsController < HxApplicationController

	before_filter :may_view_subjects_required

	def index
		hx = Project.find_by_code('HomeExposures')
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
#		params[:projects] ||= {}
#		params[:projects][hx.id] ||= {}
#		@subjects = Subject.search(params)
		@subjects = hx.subjects.search(params.merge(
			#	interview outcome == 'complete'
			#	sample outcome == 'complete'
			:interview_outcome => 'complete',
			:sample_outcome => 'complete'
		))
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "hx/subjects/index"
		end
	end

end
