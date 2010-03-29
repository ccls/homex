class ResponseSetsController < ApplicationController

	before_filter :may_take_surveys_required

	before_filter :valid_survey_required,     :only => :create
	before_filter :valid_subject_id_required, :only => :create
	before_filter :limit_response_set_count,  :only => :create

	def create

#	include subject_id or child_id or whatever in ResponseSet

		@response_set = ResponseSet.create( :survey => @survey,
			:subject_id => params[:subject_id] )
		if !@response_set.new_record?
			redirect_to(
				edit_my_survey_path(
					:survey_code => @survey.access_code, 
					:response_set_code	=> @response_set.access_code
				)
			)
		else
			flash[:error] = "Unable to create a new response set"
			redirect_to( subjects_path )
		end
	end


protected

	#	A valid survey code must be passed to begin.
	def valid_survey_required
		unless (@survey = Survey.find_by_access_code(params[:survey_code]))
#			flash[:error] = "Unable to find that survey"
#			redirect_to( available_surveys_path )
			access_denied("Unable to find that survey")
		end
	end

	#	A subject_id must be present and the associated
	#	Subject must exist.
	def valid_subject_id_required
		unless( Subject.exists?( params[:subject_id] ) )
			access_denied("Subject ID Required to take survey")
		end
	end

	#	Limit the number of response sets to 2 per subject.
	def limit_response_set_count
		if ResponseSet.count(:conditions => { 
				:survey_id => @survey,
				:subject_id => params[:subject_id]
			}) >= 2
			access_denied("Subject has already completed the survey twice.")
		end
	end

end