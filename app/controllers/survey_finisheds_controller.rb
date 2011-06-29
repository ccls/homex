#	This controller serves one purpose.  It is the destination
#	after completion of a survey.  This is set in 
#		config/initializers/surveyor.rb 
#	There are no views, just logic to control a redirect.
class SurveyFinishedsController < ApplicationController
#
#	before_filter :may_read_subjects_required
#
#	def show
#		flash[:notice] = "Survey complete"
#		if session[:access_code] &&
#			rs = ResponseSet.find_by_access_code(session[:access_code])
#			session[:access_code] = nil
##			redirect_to interview_subject_path(rs.subject)
#			redirect_to subject_response_sets_path(rs.subject)
#		else
#			redirect_to root_path
#		end
#	end
#
end
