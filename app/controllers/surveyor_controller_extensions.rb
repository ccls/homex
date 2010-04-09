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
			before_filter :block_all_access, :only => [ :new, :create ]

			#	due to filter ordering, I want to allow the 
			#	block_all_access to deal with this so I added
			#	the :except => [].  I don't know. It works.
			skip_before_filter :cas_filter, :except => [ :new, :create ]
			#before_filter :cas_gateway_filter

#			before_filter :may_take_surveys_required
			before_filter :permission_or_invitation_required

			before_filter :response_set_must_not_be_complete, :only => :edit

			layout 'survey'
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

		def permission_or_invitation_required
			unless( SurveyInvitation.exists?(:token => session[:invitation]) ) ||
				( logged_in? && current_user.may_take_surveys? )
				access_denied("You don't have permission to take surveys.")
			end
		end

	end
	
	module Actions
	end
end
