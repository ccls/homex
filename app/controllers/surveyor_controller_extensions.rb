module SurveyorControllerExtensions
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			# Same as typing in the class

			before_filter :may_take_surveys_required

			before_filter :valid_subject_id_required, :only => :create
			before_filter :limit_response_set_count,  :only => :create

			before_filter :response_set_must_not_be_complete, :only => :edit
		end
	end
	
	module ClassMethods
	end
	
	module InstanceMethods
		#	Once marked as complete, it is no longer editable
		def response_set_must_not_be_complete
			if @response_set = ResponseSet.find_by_access_code(params[:response_set_code]).is_complete?
				access_denied("This response set is already marked complete.")
			end
		end

		#	A subject_id must be present and the associated
		#	Subject must exist.
		def valid_subject_id_required
#			if params[:subject_id].nil? 
#				access_denied("Subject ID Required to take survey")
#			else
#
#			end
		end

		#	Limit the number of response sets to 2 per subject.
		def limit_response_set_count
#			if ResponseSet.count(:conditions => { 
#				:subject_id => params[:subject_id]
#				}) >= 2
#				access_denied("Subject has already completed the survey twice.")
#			end
		end
	end
	
	module Actions
		# Redefine the controller actions [index, new, create, show, update] here
		# def new
		#	 render :text =>"surveys are down"
		# end

#		def new
#			@surveys = Survey.find(:all)
#			unless available_surveys_path == surveyor_default(:index)
#				redirect_to surveyor_default(:index)
#			end
#		end

		def create

#	include subject_id or child_id or whatever in ResponseSet

			if (@survey = Survey.find_by_access_code(params[:survey_code])) && 
				(@response_set = ResponseSet.create(
					:survey => @survey, 
					:user_id => (
						@current_user.nil? ? @current_user : @current_user.id
					))
				)
				flash[:notice] = "Survey was successfully started."
				redirect_to(
					edit_my_survey_path(
						:survey_code => @survey.access_code, 
						:response_set_code	=> @response_set.access_code
					)
				)
			else
				flash[:notice] = "Unable to find that survey"
				redirect_to( available_surveys_path )
			end
		end

	end
end

# Set config['extend_controller'] = true in config/initializers/surveyor.rb to activate these extensions
