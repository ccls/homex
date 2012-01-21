class StudySubjectsController < ApplicationController

#	FYI. Now that I've explicitly added the code here, it may not be 100% covered by testing.

	before_filter :may_create_study_subjects_required,
		:only => [:new,:create]
	before_filter :may_read_study_subjects_required,
		:only => [:show,:index]
	before_filter :may_update_study_subjects_required,
		:only => [:edit,:update]
	before_filter :may_destroy_study_subjects_required,
		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]

	def index
		record_or_recall_sort_order
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		@study_subjects = StudySubject.search(params.dup.deep_merge(
			:projects=>{ Project['HomeExposures'].id => {} }
		))
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
		end
	end

	def show
		#	always return an enrollment so its not nil
		#	although it may be misleading
		#	Of course, if the subject isn't enrolled, 
		#	they wouldn't be here.
		@hx_enrollment = @study_subject.enrollments.find_by_project_id(
			Project['HomeExposures'].id) || @study_subject.enrollments.new
	end

	def new
		@study_subject = StudySubject.new
	end

	def create
		@study_subject = StudySubject.new(params[:study_subject])
		@study_subject.save!
		flash[:notice] = 'Success!'
		redirect_to @study_subject
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating " <<
			"the study_subject"
		render :action => "new"
	end 

	def update
		@study_subject.update_attributes!(params[:study_subject])
		flash[:notice] = 'Success!'
		redirect_to study_subject_path(@study_subject)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating " <<
			"the study_subject"
		render :action => "edit"
	end

	def destroy
		@study_subject.destroy
		redirect_to study_subjects_path
	end

protected

	def valid_id_required
		if( !params[:id].blank? && StudySubject.exists?(params[:id]) )
			@study_subject = StudySubject.find(params[:id])
		else
			access_denied("Valid id required!", study_subjects_path)
		end
	end

end

__END__

class StudySubjectsController < ApplicationController

	resourceful :update_redirect => :update_redirect_path

	skip_before_filter :get_all

	def index
		record_or_recall_sort_order
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		@study_subjects = StudySubject.search(params.dup.deep_merge(
			:projects=>{ Project['HomeExposures'].id => {} }
		))
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
		end
	end

	def show
		#	always return an enrollment so its not nil
		#	although it may be misleading
		#	Of course, if the subject isn't enrolled, 
		#	they wouldn't be here.
		@hx_enrollment = @study_subject.enrollments.find_by_project_id(
			Project['HomeExposures'].id) || @study_subject.enrollments.new
	end

protected

	def update_redirect_path
		study_subject_path(@study_subject)
	end

end

