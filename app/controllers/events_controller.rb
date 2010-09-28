class EventsController < ApplicationController

#	before_filter :may_create_events_required, 
#		:only => [:new,:create]
	before_filter :may_read_events_required, 
		:only => [:show,:index]
#	before_filter :may_update_events_required, 
#		:only => [:edit,:update]
#	before_filter :may_destroy_events_required,
#		:only => :destroy

	before_filter :valid_hx_subject_id_required,
		:only => [:new,:create,:index]
#	before_filter :valid_id_required,
#		:only => [:show,:edit,:update]


	def index
		hx_enrollment = @subject.hx_enrollment
		@events = if hx_enrollment
			hx_enrollment.operational_events.search(params)
		else
			[]
		end
	end

protected

#	def valid_id_required
#		if !params[:id].blank? and OperationalEvent.exists?(params[:id])
#			@event = OperationalEvent.find(params[:id])
#		else
#			access_denied("Valid event id required!", 
#				subjects_path)
#		end
#	end

end
