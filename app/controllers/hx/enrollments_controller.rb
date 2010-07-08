class Hx::EnrollmentsController < HxApplicationController

	before_filter :valid_hx_subject_id_required,
		:only => [:new,:create,:index]
	before_filter :valid_id_required,
		:only => [:edit,:update]

	def new
		get_unenrolled_projects
	end

	def create
		@enrollment = @subject.enrollments.build(
			{:project_id => params[:project_id]})
		@enrollment.save!
		redirect_to edit_hx_enrollment_path(@enrollment)
	rescue ActiveRecord::RecordNotSaved
		get_unenrolled_projects
		flash.now[:error] = "Enrollment creation failed"
		render :action => 'new'
	end

	def update
		@enrollment.update_attributes!(params[:enrollment])
		redirect_to hx_subject_enrollments_path(@enrollment.subject)
	rescue ActiveRecord::RecordNotSaved
		flash.now[:error] = "Enrollment update failed"
		render :action => 'edit'
	end

protected

	def valid_id_required
		if !params[:id].blank? and Enrollment.exists?(params[:id])
			@enrollment = Enrollment.find(params[:id])
		else
			access_denied("Valid enrollment id required!", 
				hx_subjects_path)
		end
	end

	#	May be a good idea to move this to the model.
	def get_unenrolled_projects
		@projects = Project.all(
			:joins => "LEFT JOIN enrollments ON " <<
				"projects.id = enrollments.project_id AND " <<
				"enrollments.subject_id = #{@subject.id}",
			:conditions => [ "enrollments.subject_id IS NULL" ])
	end

end
