class Interview::StudySubjectsController < ApplicationController

	permissive

	before_filter :valid_id_for_hx_study_subject_required,
		:only => [:show]

#	before_filter :valid_hx_interview_required,
#		:only => :show

	def index
		record_or_recall_sort_order
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		@study_subjects = StudySubject.for_hx_interview(params)
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=study_subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "study_subjects/index"
		end
	end

	def show
#		redirect_to interview_path(@interview)
#		@interviews = @study_subject.identifier.try(:interviews)||[]
		@interviews = @study_subject.try(:interviews)||[]
	end

protected

#	def valid_hx_interview_required
#		@interview = @study_subject.hx_interview
#		if @interview.nil?
#			access_denied("Valid hx interview required!", 
#				interview_study_subjects_path)
#		end
#	end

end
