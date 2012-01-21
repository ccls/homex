class EventsController < ApplicationController

#	permissive

	before_filter :may_create_events_required,
		:only => [:new,:create]
	before_filter :may_read_events_required,
		:only => [:show,:index]
	before_filter :may_update_events_required,
		:only => [:edit,:update]
	before_filter :may_destroy_events_required,
		:only => :destroy

	before_filter :valid_hx_study_subject_id_required,
		:only => [:new,:create,:index]

	def index
		@events = if hxe = @study_subject.enrollments.find_by_project_id(Project['HomeExposures'].id)
			hxe.operational_events.search(params)
		else
			[]
		end
	end

end
