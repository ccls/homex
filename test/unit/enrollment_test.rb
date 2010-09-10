require File.dirname(__FILE__) + '/../test_helper'

class EnrollmentTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:project,:subject)
	assert_should_belong_to(:ineligible_reason,:refusal_reason,
		:document_version)
	assert_should_initially_belong_to(:project,:subject)

	assert_should_require_unique(:project_id, 
		:scope => :subject_id)

	test "should create enrollment" do
		assert_difference 'Enrollment.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require consented_on be in the past" do
		assert_difference('Enrollment.count',0) do
			object = create_object(
				:consented_on => nil,
				:consented_on_string => 'tomorrow')
			assert object.errors.on(:consented_on)
			assert_match(/future/,
				object.errors.on(:consented_on))
		end
	end

	test "should require completed_on be in the past" do
		assert_difference('Enrollment.count',0) do
			object = create_object(
#				:completed_on => nil,
				:completed_on_string => 'tomorrow')
			#	I don't quite understand why this doesn't
			#	do what I expect.  I think that setting both
			#	at the same time is part of the problem.
			#	completed_on_string gets set first, and then
			#	completed_on gets set to nil, undoing it.
			#		update_attribute (singular) does NOT
			#		do validations
			#	completed_on is not set in the factory
			#	definition so leave it alone.
#			object.update_attributes(:completed_on_string => 'tomorrow')

			#	sometimes this fails during test:coverage?
			assert object.errors.on(:completed_on)
			assert_match(/future/,
				object.errors.on(:completed_on))
		end
	end

	test "should require ineligible_reason if is_eligible == false" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_eligible => false)
			assert object.errors.on(:ineligible_reason)
		end
	end

	test "should require ineligible_reason_specify if " <<
			"ineligible_reason == other" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:ineligible_reason_id => 
				IneligibleReason.find_by_code('other').id )
			assert object.errors.on(:ineligible_reason_specify)
		end
	end

	test "should require reason_not_chosen if is_chosen == false" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_chosen => false)
			assert object.errors.on(:reason_not_chosen)
		end
	end

	test "should require refusal_reason if consented == false" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => false)
			assert object.errors.on(:refusal_reason)
		end
	end

	test "should require other_refusal_reason if " <<
			"refusal_reason == other" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:refusal_reason_id => 
				RefusalReason.find_by_code('other').id )
			assert object.errors.on(:other_refusal_reason)
		end
	end

	test "should require consented_on if consented == true" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => true,
				:consented_on => nil)
			assert object.errors.on(:consented_on)
		end
	end

	test "should require terminated_reason if " <<
			"terminated_participation == true" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:terminated_participation => true)
			assert object.errors.on(:terminated_reason)
		end
	end

	test "should require completed_on if is_complete == true" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_complete => true)
			assert object.errors.on(:completed_on)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:enrollment,options)
		record.save
		record
	end

end
