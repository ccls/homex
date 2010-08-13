class PatientsController < HxApplicationController

	before_filter :may_edit_required

	before_filter :valid_hx_subject_id_required
	before_filter :valid_patient_required,
		:only => [:edit,:update,:show,:destroy]
	
#		def new
#			@hospital = Hospital.new
#		end
#	
#		def create
#			@hospital = @subject.hospitals.build(params[:hospital])
#			@hospital.save!
#			redirect_to subject_hospitals_path(@hospital.subject)
#		rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
#			flash.now[:error] = "Hospital creation failed"
#			render :action => 'new'
#		end
#	
#Editors can modify the current address and designated it as being an invalid address. If they designated the address as invalid, the why_invalid text field is mandatory.
#
#By default, there is no value for whether an address is valid.
#
#As part of subject tracing, we will have the ability to designated whether an address we have has been verified by some means. When an address is verified, the user will set is_verified to true. They will then be required to provide a value for the how_verified field and the system will capture both their user_id in verified_by and the current date in verified_on fields.
	
#		def update
#			@hospital.update_attributes!(params[:hospital])
#			redirect_to subject_hospitals_path(@hospital.subject)
#		rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
#			flash.now[:error] = "Hospital update failed"
#			render :action => 'edit'
#		end
	
protected

	def valid_patient_required
		@patient = @subject.patient 
	end

end
