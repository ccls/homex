require File.dirname(__FILE__) + '/../test_helper'

class PatientTest < ActiveSupport::TestCase

	test "should create patient" do
		assert_difference 'Patient.count' do
			patient = create_patient
			assert !patient.new_record?, 
				"#{patient.errors.full_messages.to_sentence}"
		end
	end

	test "should belong to subject" do
		patient = create_patient
		assert_nil patient.subject
		patient.subject = Factory(:subject)
		assert_not_nil patient.subject
	end


protected

	def create_patient(options = {})
		record = Factory.build(:patient,options)
		record.save
		record
	end

end
