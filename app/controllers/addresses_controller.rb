class AddressesController < HxApplicationController

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
		redirect_to subject_addresses_path(@address.subject)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Address creation failed"
		render :action => 'new'
	end

#Editors can modify the current address and designated it as being an invalid address. If they designated the address as invalid, the why_invalid text field is mandatory.
#
#By default, there is no value for whether an address is valid.
#
#As part of subject tracing, we will have the ability to designated whether an address we have has been verified by some means. When an address is verified, the user will set is_verified to true. They will then be required to provide a value for the how_verified field and the system will capture both their user_id in verified_by and the current date in verified_on fields.

	def update
		@address.update_attributes!(params[:address])
		redirect_to subject_addresses_path(@address.subject)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Address update failed"
		render :action => 'edit'
	end

protected

	def valid_id_required
		if !params[:id].blank? and Address.exists?(params[:id])
			@address = Address.find(params[:id])
		else
			access_denied("Valid address id required!", 
				subjects_path)
		end
	end

end
