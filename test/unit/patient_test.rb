require File.dirname(__FILE__) + '/../test_helper'

class PatientTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:subject)
	assert_should_belong_to(:organization,:diagnosis)
	assert_should_require_attributes(:subject_id)
	assert_should_require_unique_attributes(:subject_id)
	assert_requires_valid_association(:subject)


	test "should require Case subject" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:subject => Factory(:subject))
			assert object.errors.on(:subject)
		end
	end

	test "should require valid subject_id" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:subject_id => 0)
			assert object.errors.on(:subject)
		end
	end

	test "should require diagnosis_date be in the past" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:diagnosis_date => Chronic.parse('tomorrow'))
			assert object.errors.on(:diagnosis_date)
			assert_match(/future/,
				object.errors.on(:diagnosis_date))
		end
	end

	test "should require diagnosis_date be after DOB" do
		assert_difference( "#{model_name}.count", 0 ) do
			subject = Factory(:case_subject)
			pii = Factory(:pii,:subject_id => subject.id)
			object = create_object(
				:subject_id => subject.id,
				:diagnosis_date => Date.jd(2430000) ) 
				# smaller than my factory set dob
			assert object.errors.on(:diagnosis_date)
			assert_match(/before.*dob/,
				object.errors.on(:diagnosis_date))
		end
	end

end
