class SurveyFinishedsController < ApplicationController

	skip_before_filter :cas_filter

	layout 'survey'

	def show
		if SurveyInvitation.exists?(:token => session[:invitation])
			session[:invitation] = nil
		else
			flash[:notice] = "Survey complete"
			redirect_to root_path
		end
	end

end
