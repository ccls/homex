class Hx::AddressesController < HxApplicationController

	before_filter :valid_hx_subject_id_required,
		:only => [:new,:create,:index]
	before_filter :valid_id_required,
		:only => [:edit,:update]

	def new
		@address = Address.new
	end

	def create
		@address = @subject.addresses.build(params[:address])
		@address.save!
		redirect_to hx_subject_addresses_path(@address.subject)
	rescue ActiveRecord::RecordNotSaved
		flash.now[:error] = "Address creation failed"
		render :action => 'new'
	end

	def update
		@address.update_attributes!(params[:address])
		redirect_to hx_subject_addresses_path(@address.subject)
	rescue ActiveRecord::RecordNotSaved
		flash.now[:error] = "Address update failed"
		render :action => 'edit'
	end

protected

	def valid_id_required
		if !params[:id].blank? and Address.exists?(params[:id])
			@address = Address.find(params[:id])
		else
			access_denied("Valid address id required!", 
				hx_subjects_path)
		end
	end

end
