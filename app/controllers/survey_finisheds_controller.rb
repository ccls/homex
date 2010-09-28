class SurveyFinishedsController < ApplicationController

#	skip_before_filter :login_required

#	before_filter :may_create_subjects_required, 
#		:only => [:new,:create]
	before_filter :may_read_subjects_required		#, 
#		:only => [:show,:index]
#	before_filter :may_update_subjects_required, 
#		:only => [:edit,:update]
#	before_filter :may_destroy_subjects_required,
#		:only => :destroy

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
				redirect_to interview_subject_path(rs.subject)
			else
				redirect_to root_path
			end
#		end
	end

end
