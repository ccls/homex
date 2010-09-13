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

	test "should require diagnosis_date be in the past" do
		assert_difference('Patient.count',0) do
			object = create_object(
				:diagnosis_date_string => 'tomorrow')
			assert object.errors.on(:diagnosis_date)
			assert_match(/future/,
				object.errors.on(:diagnosis_date))
		end
	end

	test "should require diagnosis_date be after DOB" do
		assert_difference('Patient.count',0) do
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

protected

	def create_object(options = {})
		record = Factory.build(:patient,options)
		record.save
		record
	end

end
