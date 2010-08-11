class ProjectsController < ApplicationController

#	before_filter :may_view_projects_required
	before_filter :may_view_required

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]

	def index
		@projects = Project.all
	end

	def new
		@project = Project.new
	end

	def create
		@project = Project.new(params[:project])
		@project.save!
		flash[:notice] = 'Success!'
		redirect_to @project
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the project"
		render :action => "new"
	end

	def update
		@project.update_attributes!(params[:project])
		redirect_to @project
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the project"
		render :action => "edit"
	end

	def destroy
		@project.destroy
		redirect_to projects_path
	end

protected

	def valid_id_required
		if !params[:id].blank? and Project.exists?(params[:id])
			@project = Project.find(params[:id])
		else
			access_denied("Valid id required!", projects_path)
		end
	end

end
