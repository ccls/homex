class EventsController < ApplicationController

	permissive

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
