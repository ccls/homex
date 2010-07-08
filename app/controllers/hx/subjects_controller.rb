class Hx::SubjectsController < HxApplicationController

	before_filter :may_view_subjects_required
	before_filter :valid_id_for_hx_subject_required, 
		:only => [:edit,:show,:update,:destroy]
#	before_filter :get_subjects, :only => [:index,:general]
	before_filter :get_subjects, :only => [:index]

#	layout 'home_exposure'

#	def general
#		render :action => 'index'
#	end

	def index
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
		end
	end

	def show
		@projects = Project.all
		@project_subjects = @subject.project_subjects
	end

	def edit
	end

	def update
		@subject.update_attributes!(params[:subject])
		flash[:notice] = 'Subject was successfully updated.'
		redirect_to(hx_subject_path(@subject))
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the subject."
		render :action => "edit"
	end

	def destroy
		@subject.destroy
		redirect_to(hx_subjects_path)
	end

protected

#	def valid_id_required
#		if !params[:id].blank? and Subject.exists?(params[:id])
#			@subject = Subject.find(params[:id])
#		else
#			access_denied("Valid subject id required!", hx_subjects_path)
#		end
#	end

	def get_subjects
		hx = Project.find_by_code('HomeExposures')
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
#		params[:projects] ||= {}
#		params[:projects][hx.id] ||= {}
#		@subjects = Subject.search(params)
		@subjects = hx.subjects.search(params)
	end

end
