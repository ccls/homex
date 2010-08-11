class SamplesController < HxApplicationController

#	before_filter :may_view_samples_required
	before_filter :may_administrate_required

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
		else
			access_denied("Valid sample id required!", 
				subjects_path)
		end
	end

end
