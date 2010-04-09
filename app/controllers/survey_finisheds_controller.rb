class SurveyFinishedsController < ApplicationController

	skip_before_filter :cas_filter

	layout 'survey'

	def show
		flash[:notice] = "Survey complete"
		if SurveyInvitation.exists?(:token => session[:invitation])
			si = SurveyInvitation.find_by_token(session[:invitation])
			SurveyInvitationMailer.deliver_thank_you(si)
			session[:invitation] = nil
		else
			redirect_to root_path
		end
	end

end
