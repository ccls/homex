class Hx::SamplesController < HxApplicationController

	before_filter :may_view_samples_required
	before_filter :valid_id_for_hx_subject_required,
		:only => [:new,:create,:index]
	before_filter :valid_id_required,
		:only => [:show,:edit,:update,:destroy]

	def new
		@sample = @subject.samples.new
	end

	def create
		redirect_to hx_subjects_path



	end

	def update
		@sample.update_attributes!(params[:sample])
		redirect_to hx_subjects_path


	end

	def index
		@samples = @subject.samples
	end

	def destroy
		@sample.destroy
		redirect_to hx_subjects_path
	end

protected

	def valid_id_required
		if !params[:id].blank? and Sample.exists?(params[:id])
			@sample = Sample.find(params[:id])
		else
			access_denied("Valid sample id required!", 
				hx_subjects_path)
		end
	end

end
