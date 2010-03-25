module SurveyorControllerExtensions
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do

#	new and create will be done differently.  block access
#	here for security reasons.  The contents of "new" will be done 
#	within another page.  Probably subject#show or #index.
#	From there, they will use response_set#create which makes
#	much more sense.  The editing and updating will still all
#	be done via the surveyor controller.
#			before_filter :block_all_access, :only => [ :new, :create ]

			before_filter :may_take_surveys_required
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

	end
	
	module Actions
		# Redefine the controller actions [index, new, create, show, update] here
		# def new
		#	 render :text =>"surveys are down"
		# end

		def create

#	include subject_id or child_id or whatever in ResponseSet

			if (@survey = Survey.find_by_access_code(params[:survey_code])) && 
				(@response_set = ResponseSet.create(
					:survey => @survey, 
					:user_id => (
						@current_user.nil? ? @current_user : @current_user.id
					))
				)
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
