class He::FollowupsController < ApplicationController

	before_filter :may_view_subjects_required

	layout 'home_exposure'

	def index
		@subjects = Subject.search(params)
		render :template => "he/subjects/index"
	end

end
