class HomeExposuresController < ApplicationController

	before_filter :may_view_subjects_required

#	layout 'home_exposure'

	def show
		@page = Page.by_path("/home_exposure")
	end

end
