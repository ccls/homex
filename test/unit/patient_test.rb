require File.dirname(__FILE__) + '/../test_helper'

class PatientTest < ActiveSupport::TestCase

	assert_should_initially_belong_to(:subject)
	assert_should_belong_to(:organization,:diagnosis)

	test "should create patient" do
		assert_difference 'Patient.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require valid subject_id on update" do
		assert_difference 'Patient.count', 1 do
			object = create_object(:subject_id => 0)
			object.reload.update_attributes(:hospital_no => 1)
			assert object.errors.on(:subject)
		end
	end

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
	test "should require subject_id on update" do
		assert_difference 'Patient.count', 1 do
			object = create_object(:subject_id => nil)
			object.reload.update_attributes(:hospital_no => 1)
			assert object.errors.on(:subject)
		end
	end

	test "should require unique subject_id" do
		subject = create_object.subject
		assert_difference( 'Patient.count', 0 ) do
			object = create_object(:subject => subject)
			assert object.errors.on(:subject_id)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:patient,options)
		record.save
		record
	end

end
