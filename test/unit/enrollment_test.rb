require File.dirname(__FILE__) + '/../test_helper'

class EnrollmentTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:project,:subject)
	assert_should_belong_to(:ineligible_reason,:refusal_reason,
		:document_version)
	assert_should_have_many(:operational_events)
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
				:consented_on => Chronic.parse('tomorrow'))
			assert object.errors.on(:consented_on)
			assert_match(/future/,
				object.errors.on(:consented_on))
		end
	end

	test "should require completed_on be in the past" do
		assert_difference('Enrollment.count',0) do
			object = create_object(
				:completed_on => Chronic.parse('tomorrow'))
			#	sometimes this fails during test:coverage?
			assert object.errors.on(:completed_on)
			assert_match(/future/,
				object.errors.on(:completed_on))
		end
	end


	test "should require ineligible_reason if is_eligible == 2" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_eligible => 2)
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

	test "should require reason_not_chosen if is_chosen == 2" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_chosen => 2)
			assert object.errors.on(:reason_not_chosen)
		end
	end

	test "should require refusal_reason if consented == 2" do
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

	test "should require consented_on if consented == 1" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => 1,
				:consented_on => nil)
			assert object.errors.on(:consented_on)
		end
	end

	test "should require terminated_reason if " <<
			"terminated_participation == 1" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:terminated_participation => 1)
			assert object.errors.on(:terminated_reason)
		end
	end

	test "should require completed_on if is_complete == 1" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_complete => 1)
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
