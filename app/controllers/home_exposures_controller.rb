class HomeExposuresController < ApplicationController

#	before_filter :may_view_subjects_required
	before_filter :may_view_required

	def show
		@page = Page.by_path("/")
	end

end
