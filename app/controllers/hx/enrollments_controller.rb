class Hx::EnrollmentsController < HxApplicationController

	before_filter :valid_hx_subject_id_required,
		:only => [:new,:create,:index]
	before_filter :valid_id_required,
		:only => [:edit,:update]

	def new
		@project_subject = ProjectSubject.new
	end

	def create
		@project_subject = @subject.project_subjects.build(params[:project_subject])
		@project_subject.save!
		redirect_to hx_subject_enrollments_path(@project_subject.subject)
	rescue ActiveRecord::RecordNotSaved
		flash.now[:error] = "ProjectSubject creation failed"
		render :action => 'new'
	end

	def update
		@project_subject.update_attributes!(params[:project_subject])
		redirect_to hx_subject_enrollments_path(@project_subject.subject)
	rescue ActiveRecord::RecordNotSaved
		flash.now[:error] = "ProjectSubject update failed"
		render :action => 'edit'
	end

protected

	def valid_id_required
		if !params[:id].blank? and ProjectSubject.exists?(params[:id])
			@project_subject = ProjectSubject.find(params[:id])
		else
			access_denied("Valid project_subject id required!", 
				hx_subject_enrollments_path)
		end
	end

end
