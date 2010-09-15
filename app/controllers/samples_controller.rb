class SamplesController < ApplicationController

	before_filter :may_create_samples_required, 
		:only => [:new,:create]
	before_filter :may_read_samples_required, 
		:only => [:show,:index]
	before_filter :may_update_samples_required, 
		:only => [:edit,:update]
	before_filter :may_destroy_samples_required,
		:only => :destroy

	before_filter :valid_hx_subject_id_required,
		:only => [:new,:create,:index]
	before_filter :valid_id_required,
		:only => [:show,:edit,:update,:destroy]

	def new
		@sample = @subject.samples.new
	end

	def create
		@sample = @subject.samples.new(params[:sample])
		@sample.save!
		redirect_to sample_path(@sample)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "Sample creation failed."
		render :action => 'new'
	end

	def update
		@sample.update_attributes!(params[:sample])
		redirect_to subjects_path
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "Sample update failed."
		render :action => 'edit'
	end

	def index
		@samples = @subject.samples
	end

	def destroy
		@sample.destroy
		redirect_to subjects_path
	end

protected

	def valid_id_required
		if !params[:id].blank? and Sample.exists?(params[:id])
			@sample = Sample.find(params[:id])
			@subject = @sample.subject
		else
			access_denied("Valid sample id required!", 
				subjects_path)
		end
	end

end
