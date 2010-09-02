require File.dirname(__FILE__) + '/../test_helper'

class PatientTest < ActiveSupport::TestCase

	assert_should_initially_belong_to(:subject)
	assert_should_belong_to(:organization,:diagnosis)
	assert_should_require(:subject_id)
	assert_should_require_unique(:subject_id)

	test "should create patient" do
		assert_difference 'Patient.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require Case subject" do
		assert_difference( 'Patient.count', 0 ) do
			object = create_object(:subject => Factory(:subject))
			assert object.errors.on(:subject)
		end
	end

	test "should require valid subject_id" do
		assert_difference( 'Patient.count', 0 ) do
			object = create_object(:subject_id => 0)
			assert object.errors.on(:subject)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:patient,options)
		record.save
		record
	end

end
