class Hx::Sample::SubjectsController < HxApplicationController

	before_filter :may_view_subjects_required
	before_filter :get_subjects, :except => :show
	before_filter :valid_id_for_hx_subject_required,
		:only => [:show]

	def index
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "hx/subjects/index"
		end
	end

	def send_to_lab
	end

protected

	def get_subjects

#	interview outcome == 'complete'
#	sample outcome != 'complete'

		hx = Project.find_by_code('HomeExposures')
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
#		params[:projects] ||= {}
#		params[:projects][hx.id] ||= {}
#		@subjects = Subject.search(params)
		@subjects = hx.subjects.search(params)
	end

end
