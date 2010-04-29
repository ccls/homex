class ProjectsController < ApplicationController
#
#	I think that a Project and a StudyEvent are the same thing
#
	before_filter :may_view_projects_required
	before_filter :valid_id_required, :only => [:show,:edit,:update,:destroy]

	def new
		@project = StudyEvent.new
	end

	def create
		@project = StudyEvent.new(params[:project])
		@project.save!
		flash[:notice] = 'Success!'
		redirect_to project_path(@project.id)
	rescue ActiveRecord::RecordNotSaved
		flash.now[:error] = "There was a problem creating the project"
		render :action => "new"
	end

	def update
		@project.update_attributes!(params[:project])
		redirect_to project_path(@project.id)
	rescue ActiveRecord::RecordNotSaved
		flash.now[:error] = "There was a problem updating the project"
		render :action => "edit"
	end

	def destroy
		if @project.destroy
			flash[:error] = "Project destruction failed."
		end
		redirect_to projects_path
	end

protected

	def valid_id_required
		if !params[:id].blank? and StudyEvent.exists?(params[:id])
			@project = StudyEvent.find(params[:id])
		else
			access_denied("Valid id required!", projects_path)
		end
	end

end
