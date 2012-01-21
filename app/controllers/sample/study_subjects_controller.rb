class Sample::StudySubjectsController < ApplicationController

#	permissive

	before_filter :may_create_study_subjects_required,
		:only => [:new,:create]
	before_filter :may_read_study_subjects_required, 
		:only => [:show,:index,:send_to_lab]
	before_filter :may_update_study_subjects_required,
		:only => [:edit,:update]
	before_filter :may_destroy_study_subjects_required,
		:only => :destroy

	before_filter :valid_id_for_hx_study_subject_required,
		:only => [:show]

	def index
		get_study_subjects
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=study_subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "study_subjects/index"
		end
	end

#	def send_to_lab
#		get_study_subjects
#	end

protected

	def get_study_subjects
		record_or_recall_sort_order
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		@study_subjects = StudySubject.search(params.dup.deep_merge(
			:projects=>{ Project['HomeExposures'].id =>{}},
			#:sample_outcome => 'incomplete',
			:interview_outcome => 'complete'
		))
	end

end
