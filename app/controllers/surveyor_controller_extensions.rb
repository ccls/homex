module SurveyorControllerExtensions	#	:nodoc:
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			#
			#	new and create will be done differently.  block access
			#	here for security reasons.  The contents of "new" will be done 
			#	within another page.  Probably subject#show or #index.
			#	From there, they will use response_set#create which makes
			#	much more sense.  The editing and updating will still all
			#	be done via the surveyor controller.
			#
			before_filter :block_all_access, :only => [ :new, :create ]

			#
			#	Don't do any CAS stuff so that subjects can take the
			#	survey themselves.  If we don't do this, comment out this
			#	skip and "permission_or_invitation" and i
			#	uncomment the "may_take...".
			#
			skip_before_filter :login_required
#			before_filter :may_take_surveys_required

#	this will stop a user from completing a survey
#	which I don't understand
#			before_filter :cas_gateway_filter, :only => [:edit,:update]

			#
			#	FYI...
			#
			#	If an interviewer logs out during a survey,
			#	their session is still open to complete the survey here
			#	because of skipping the cas_filter.
			#

			before_filter :valid_response_set_required
			before_filter :permission_or_invitation_required
			before_filter :response_set_must_not_be_complete
		end
	end
	
	module ClassMethods
	end
	
	module InstanceMethods

		#	Once marked as complete, it is no longer editable
		def response_set_must_not_be_complete
			if @response_set.is_complete?
				access_denied("This response set is already marked complete.")
			end
		end

		def permission_or_invitation_required
			si = SurveyInvitation.find_by_token(session[:invitation])
			unless( si.try(:response_set_id) == @response_set.id ) ||
#				( logged_in? && current_user.may_take_surveys? )
				( logged_in? && current_user.may_edit_response_sets? )
				access_denied("You don't have permission to take surveys.")
			end
		end

		def valid_response_set_required
			unless @response_set = ResponseSet.find_by_access_code(
					params[:response_set_code])
				access_denied("Valid response set code required.")
			end
		end

	end
	
	module Actions
	end
end
