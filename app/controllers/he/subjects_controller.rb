class He::SubjectsController < ApplicationController

	before_filter :may_view_subjects_required
	before_filter :valid_id_required, :only => [:edit,:show,:update,:destroy]
	before_filter :get_subjects, :only => [:index,:general]

	layout 'home_exposure'

	def general
		render :action => 'index'
	end

	def index
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
		end
	end

	def show
		@study_events = StudyEvent.all
		@project_subjects = @subject.project_subjects
	end

	def edit
	end

	def update
		@subject.update_attributes!(params[:subject])
		flash[:notice] = 'Subject was successfully updated.'
		redirect_to(he_subject_path(@subject))
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the subject."
		render :action => "edit"
	end

	def destroy
		@subject.destroy
		redirect_to(he_subjects_path)
	end

protected

	def valid_id_required
		if !params[:id].blank? and Subject.exists?(params[:id])
			@subject = Subject.find(params[:id])
		else
			access_denied("Valid subject id required!", he_subjects_path)
		end
	end

	def get_subjects
		he = StudyEvent.find_by_description('Home Exposure')
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
#		params[:study_events] ||= {}
#		params[:study_events][he.id] ||= {}
#		@subjects = Subject.search(params)
		@subjects = he.subjects.search(params)
	end

end
