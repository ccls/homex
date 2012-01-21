class HomeExposureResponsesController < ApplicationController

#	permissive

	before_filter :may_create_home_exposure_responses_required,
		:only => [:new,:create]
	before_filter :may_read_home_exposure_responses_required,
		:only => [:show,:index]
	before_filter :may_update_home_exposure_responses_required,
		:only => [:edit,:update]
	before_filter :may_destroy_home_exposure_responses_required,
		:only => :destroy

#	TODO this is no longer tested at 100%

	before_filter :valid_study_subject_id_required
	before_filter :her_must_not_exist, :only => [:new,:create]
	before_filter :her_must_exist, :only => [:show,:destroy]
#	before_filter :two_response_sets_required, :only => [:new,:create]
#	before_filter :all_response_sets_completed_required, 
#		:only => [:new,:create]
	before_filter :her_attributes_required, :only => :create

#	def new
#		@response_sets = @study_subject.response_sets
#		@diffs = @study_subject.response_set_diffs
#	end

	def create
		@her = @study_subject.create_home_exposure_response(
			params[:home_exposure_response] )
		if @her.new_record?
			flash.now[:error] = "There was a problem creating HER"
			new
			render :action => 'new'
		else
			redirect_to study_subject_home_exposure_response_path(@study_subject)
		end
	end

	def show
	end

	def destroy
		@home_exposure_response.destroy
#		redirect_to study_subject_response_sets_path(@study_subject)
		redirect_to @study_subject
	end

protected

	def her_attributes_required
		if params[:home_exposure_response].nil? ||
			!params[:home_exposure_response].is_a?(Hash)
			access_denied("home exposure response attributes hash required",
				home_exposure_path)
		end
	end

	def her_must_exist
		if HomeExposureResponse.exists?(:study_subject_id => params[:study_subject_id] )
			@home_exposure_response = HomeExposureResponse.find(:first,
				:conditions => { :study_subject_id => @study_subject.id }
			)
		else
			access_denied("HER does not exist for this study_subject",
				home_exposure_path)
		end
	end

	def her_must_not_exist
		if HomeExposureResponse.exists?(:study_subject_id => params[:study_subject_id] )
			access_denied("HER already exists for this study_subject",
				home_exposure_path)
		end
	end

	def valid_study_subject_id_required
		if( StudySubject.exists?( params[:study_subject_id] ) )
			@study_subject = StudySubject.find( params[:study_subject_id] )
		else
			access_denied("Valid StudySubject ID required",
				home_exposure_path)
		end
	end

#	def two_response_sets_required
#		if @study_subject.response_sets.count > 2 ||
#			@study_subject.response_sets.count < 2
#			access_denied("Must complete 2 response sets before merging. " <<
#				":#{@study_subject.response_sets.count}:" ,
#				home_exposure_path)
#		end
#	end
#
#	def all_response_sets_completed_required
#		unless @study_subject.response_sets.collect(&:is_complete?).all?
#			access_denied("All response sets need to be completed",
#				home_exposure_path)
#		end
#	end

end
