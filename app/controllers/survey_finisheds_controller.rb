#	This controller serves one purpose.  It is the destination
#	after completion of a survey.  This is set in 
#		config/initializers/surveyor.rb 
#	There are no views, just logic to control a redirect.
class SurveyFinishedsController < ApplicationController

	before_filter :may_read_subjects_required

	#	We are not using survey invitations or self-administration
	#	so that code has been commented out.
	def show
		flash[:notice] = "Survey complete"
#		if SurveyInvitation.exists?(:token => session[:invitation])
#			si = SurveyInvitation.find_by_token(session[:invitation])
#			SurveyInvitationMailer.deliver_thank_you(si)
#			session[:invitation] = nil
#		else
			if session[:access_code] &&
				rs = ResponseSet.find_by_access_code(session[:access_code])
				session[:access_code] = nil
#				redirect_to interview_subject_path(rs.subject)
				redirect_to subject_response_sets_path(rs.subject)
			else
				redirect_to root_path
			end
#		end
	end

end
