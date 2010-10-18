class PatientsController < ApplicationController

	permissive

	before_filter :valid_hx_subject_id_required
	before_filter :valid_patient_required,
		:only => [:show,:edit,:update,:destroy]
	before_filter :case_subject_required,
		:only => [:new,:create]
	before_filter :no_patient_required,
		:only => [:new,:create]
	
	def show
		render :action => 'not_case' unless @subject.is_case?
	end

	def new
		flash.discard	#	dump the Patient required from 'show' redirect
		@patient = @subject.build_patient
	end

	def create
		@patient = @subject.build_patient(params[:patient])
		@patient.save!
#		flash[:notice] = "Patient created"
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
		redirect_to subject_path(@subject)
#		redirect_to subject_patient_path(@subject)
	end
	
protected

	def case_subject_required
		unless( @subject.is_case? )
			access_denied("Subject must be Case to have patient data!",
				@subject)
		end
	end

	def no_patient_required
		unless( @subject.patient.nil? )
			access_denied("Patient already exists!",
				subject_patient_path(@subject))
		end
	end

	def valid_patient_required
		if( ( @patient = @subject.patient ).nil? )
			access_denied("Valid patient required!",
				new_subject_patient_path(@subject))
		end
	end

end
