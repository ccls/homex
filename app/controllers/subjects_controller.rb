class SubjectsController < ApplicationController

	before_filter :may_create_subjects_required, 
		:only => [:new,:create]
	before_filter :may_read_subjects_required, 
		:only => [:show,:index]
	before_filter :may_update_subjects_required, 
		:only => [:edit,:update]
	before_filter :may_destroy_subjects_required,
		:only => :destroy

	before_filter :valid_id_for_hx_subject_required, 
		:only => [:edit,:show,:update,:destroy]

	def index
		remember_or_recall_sort_order
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		@subjects = Subject.for_hx(params)
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
		end
	end

	def show
#		@projects = Project.all
#		@enrollments = @subject.enrollments
		#	always return an enrollment so its not nil
		#	although it may be misleading
		#	Of course, if the subject isn't enrolled, 
		#	they wouldn't be here.
		@hx_enrollment = @subject.hx_enrollment || @subject.enrollments.new
	end

	def new
		@subject = Subject.new
	end

	def create
		@subject = Subject.new(params[:subject])
		@subject.save!
		flash[:notice] = 'Subject was successfully created.'
		redirect_to(subject_path(@subject))
	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
		flash.now[:error] = "There was a problem creating the subject"
		render :action => "new"
	end

	def edit
	end

	def update
		@subject.update_attributes!(params[:subject])
		flash[:notice] = 'Subject was successfully updated.'
		redirect_to(subject_path(@subject))
	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
		flash.now[:error] = "There was a problem updating the subject."
		render :action => "edit"
	end

	def destroy
		@subject.destroy
		redirect_to(subjects_path)
	end

end
