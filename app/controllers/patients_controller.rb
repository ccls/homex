class PatientsController < HxApplicationController

	before_filter :may_edit_required

	before_filter :valid_hx_subject_id_required
	before_filter :valid_patient_required,
		:only => [:show,:edit,:update,:destroy]
	
	def new
		@patient = @subject.build_patient
	end

	def create
		@patient = @subject.build_patient(params[:patient])
		@patient.save!
		flash[:notice] = "Patient created"
		redirect_to subject_patient_path(@subject)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Patient creation failed"
		render :action => 'new'
	end

#Editors can modify the current address and designated it as being an invalid address. If they designated the address as invalid, the why_invalid text field is mandatory.
#
#By default, there is no value for whether an address is valid.
#
#As part of subject tracing, we will have the ability to designated whether an address we have has been verified by some means. When an address is verified, the user will set is_verified to true. They will then be required to provide a value for the how_verified field and the system will capture both their user_id in verified_by and the current date in verified_on fields.
	
	def update
		@patient.update_attributes!(params[:patient])
		flash[:notice] = "Patient updated"
#		redirect_to subject_path(@subject)
		redirect_to subject_patient_path(@subject)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Patient update failed"
		render :action => 'edit'
	end

	def destroy
		@patient.destroy
#		redirect_to subject_path(@subject)
		redirect_to subject_patient_path(@subject)
	end
	
protected

	def valid_patient_required
		if( ( @patient = @subject.patient ).nil? )
			access_denied("Valid patient required!",
				new_subject_patient_path(@subject))
		end
	end

end
