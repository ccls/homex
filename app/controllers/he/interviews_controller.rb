class He::InterviewsController < ApplicationController

	before_filter :may_view_subjects_required

	layout 'home_exposure'

	def index

#	interview outcome != complete

		he = Project.find_by_description('Home Exposure')
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
#		params[:projects] ||= {}
#		params[:projects][he.id] ||= {}
#		@subjects = Subject.search(params)
		@subjects = he.subjects.search(params)
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "he/subjects/index"
		end
	end

end
