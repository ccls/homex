class HomeExposuresController < ApplicationController

#	before_filter :may_view_subjects_required
#	before_filter :may_view_required

#	This is the root path.  There should be nothing
#	here to block any user.  No filters!
	skip_before_filter :login_required

	def show
		@page = Page.by_path("/")
	end

end
