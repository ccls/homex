require File.dirname(__FILE__) + '/../test_helper'

class PatientTest < ActiveSupport::TestCase

	assert_should_belong_to(:subject)

	test "should create patient" do
		assert_difference 'Patient.count' do
			patient = create_patient
			assert !patient.new_record?, 
				"#{patient.errors.full_messages.to_sentence}"
		end
	end

	test "should require valid subject_id on update" do
		assert_difference 'Patient.count', 1 do
			patient = create_patient(:subject_id => 0)
			patient.reload.update_attributes(:hospital_no => 1)
			assert patient.errors.on(:subject)
		end
	end

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
	test "should require subject_id on update" do
		assert_difference 'Patient.count', 1 do
			patient = create_patient
			patient.reload.update_attributes(:hospital_no => 1)
			assert patient.errors.on(:subject)
		end
	end

	test "should require unique subject_id" do
		subject = Factory(:subject)
		create_patient(:subject => subject)
		assert_difference( 'Patient.count', 0 ) do
			patient = create_patient(:subject => subject)
			assert patient.errors.on(:subject_id)
		end
	end

protected

	def create_patient(options = {})
		record = Factory.build(:patient,options)
		record.save
		record
	end
	alias_method :create_object, :create_patient

end
