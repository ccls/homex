class He::SamplesController < ApplicationController

	before_filter :may_view_subjects_required

	layout 'home_exposure'

	def index

#	interview outcome == 'complete'
#	sample outcome != 'complete'

		he = StudyEvent.find_by_description('Home Exposure')
		params[:study_events] ||= {}
		params[:study_events][he.id] ||= {}
		@subjects = Subject.search(params)
		render :template => "he/subjects/index"
	end

end
