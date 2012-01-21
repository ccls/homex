class InterviewsController < ApplicationController

#	permissive

	before_filter :may_create_interviews_required,
		:only => [:new,:create]
	before_filter :may_read_interviews_required,
		:only => [:show,:index]
	before_filter :may_update_interviews_required,
		:only => [:edit,:update]
	before_filter :may_destroy_interviews_required,
		:only => :destroy

	before_filter :valid_hx_study_subject_id_required,
		:only => [:new,:create,:index]
	before_filter :valid_id_required,
		:only => [:show,:edit,:update,:destroy]

#		def new
#			@interview = @study_subject.identifier.interviews.new
#		end
#	
#		def create
#			@interview = @study_subject.identifier.interviews.new(params[:interview])
#			@interview.save!
#			redirect_to interview_path(@interview)
#		rescue ActiveRecord::RecordInvalid
#			flash.now[:error] = "Interview creation failed."
#			render :action => 'new'
#		end

	def update
		@interview.update_attributes!(params[:interview])
		redirect_to interview_path(@interview)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Interview update failed."
		render :action => 'edit'
	end

#	def index
#		@interviews = @study_subject.identifier.interviews
#	end

	def destroy
		@interview.destroy
		redirect_to study_subjects_path
	end

protected

	def valid_id_required
		if !params[:id].blank? and Interview.exists?(params[:id])
			@interview = Interview.find(params[:id])
#			require_dependency 'identifier.rb' unless Identifier #	development forgets
#			@study_subject = @interview.identifier.try(:study_subject)
			@study_subject = @interview.try(:study_subject)
		else
			access_denied("Valid interview id required!", 
				study_subjects_path)
		end
	end

end
