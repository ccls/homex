class Interview::SubjectsController < ApplicationController

	before_filter :may_create_subjects_required, 
		:only => [:new,:create]
	before_filter :may_read_subjects_required, 
		:only => [:show,:index]
	before_filter :may_update_subjects_required, 
		:only => [:edit,:update]
	before_filter :may_destroy_subjects_required,
		:only => :destroy

	before_filter :valid_id_for_hx_subject_required,
		:only => [:show]

#	before_filter :valid_hx_interview_required,
#		:only => :show

	def index
		record_or_recall_sort_order
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		@subjects = Subject.for_hx_interview(params)
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "subjects/index"
		end
	end

	def show
#		redirect_to interview_path(@interview)
		@interviews = @subject.identifier.try(:interviews)||[]
	end

protected

#	def valid_hx_interview_required
#		@interview = @subject.hx_interview
#		if @interview.nil?
#			access_denied("Valid hx interview required!", 
#				interview_subjects_path)
#		end
#	end

end
