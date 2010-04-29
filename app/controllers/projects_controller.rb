class ProjectsController < ApplicationController
#
#	I think that a Project and a StudyEvent are the same thing
#	but I think that StudyEvent sounds wrong for this context
#
	before_filter :may_view_projects_required
	before_filter :valid_id_required, :only => [:show,:edit,:update,:destroy]

	def new
		@study_event = StudyEvent.new
	end

	def create
		@study_event = StudyEvent.new(params[:study_event])
		@study_event.save!
		flash[:notice] = 'Success!'
		redirect_to project_path(@study_event.id)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the project"
		render :action => "new"
	end

	def update
		@study_event.update_attributes!(params[:study_event])
		redirect_to project_path(@study_event.id)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the project"
		render :action => "edit"
	end

	def destroy
		if @study_event.destroy
			flash[:error] = "Project destruction failed."
		end
		redirect_to projects_path
	end

protected

	def valid_id_required
		if !params[:id].blank? and StudyEvent.exists?(params[:id])
			@study_event = StudyEvent.find(params[:id])
		else
			access_denied("Valid id required!", projects_path)
		end
	end

end
