class Hx::SamplesController < HxApplicationController

	before_filter :may_view_subjects_required
	before_filter :get_subjects

#	layout 'home_exposure'

	def index
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "hx/subjects/index"
		end
	end

	def send_kits
	end

protected

	def get_subjects

#	interview outcome == 'complete'
#	sample outcome != 'complete'

		hx = Project.find_by_description('Home Exposure')
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
#		params[:projects] ||= {}
#		params[:projects][hx.id] ||= {}
#		@subjects = Subject.search(params)
		@subjects = hx.subjects.search(params)
	end

end
