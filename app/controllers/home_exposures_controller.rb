class HomeExposuresController < ApplicationController

	before_filter :may_view_subjects_required

	layout 'home_exposure'

end
