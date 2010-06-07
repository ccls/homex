class SubjectsController < ApplicationController

	before_filter :may_view_subjects_required
	before_filter :valid_id_required, :only => [:edit,:show,:update,:destroy]

	def index
		@subjects = Subject.search(params)
	end

	def show
		@study_events = StudyEvent.all
		@project_subjects = @subject.project_subjects
	end

	def new
		@subject = Subject.new
	end

	def create
		@subject = Subject.new(params[:subject])
		@subject.save!
		flash[:notice] = 'Subject was successfully created.'
		redirect_to(@subject)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the subject"
		render :action => "new"
	end

	def edit
	end

	def update
		@subject.update_attributes!(params[:subject])
		flash[:notice] = 'Subject was successfully updated.'
		redirect_to(@subject)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the subject."
		render :action => "edit"
	end

	def destroy
		@subject.destroy
		redirect_to(subjects_path)
	end

protected

	def valid_id_required
		if !params[:id].blank? and Subject.exists?(params[:id])
			@subject = Subject.find(params[:id])
		else
			access_denied("Valid subject id required!", subjects_path)
		end
	end

end
