class Followup::SubjectsController < ApplicationController

	before_filter :may_create_subjects_required, 
		:only => [:new,:create]
	before_filter :may_read_subjects_required, 
		:only => [:show,:index]
	before_filter :may_update_subjects_required, 
		:only => [:edit,:update]
	before_filter :may_destroy_subjects_required,
		:only => :destroy

	def index
		remember_or_recall_sort_order
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		@subjects = Subject.for_hx_followup(params)
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "subjects/index"
		end
	end

end
