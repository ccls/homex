require File.dirname(__FILE__) + '/../test_helper'

class EnrollmentTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:project,:subject)
	assert_should_belong_to(:ineligible_reason,:refusal_reason)
	assert_should_initially_belong_to(:project,:subject)

	test "should create enrollment" do
		assert_difference 'Enrollment.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require consented_on be in the past" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented_on_string => 'tomorrow')
			assert object.errors.on(:consented_on)
			assert_match(/future/,
				object.errors.on(:consented_on))
		end
	end

	test "should require completed_on be in the past" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:completed_on_string => 'tomorrow')
			assert object.errors.on(:completed_on)
			assert_match(/future/,
				object.errors.on(:completed_on))
		end
	end

	test "should require unique project_id and subject_id pairing" do
		p = create_object
		assert_no_difference 'Enrollment.count' do
			object = create_object({
				:project_id => p.project_id,
				:subject_id => p.subject_id
			})
			assert object.errors.on(:project_id)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:enrollment,options)
		record.save
		record
	end

end
