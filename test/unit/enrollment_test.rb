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
				:is_complete  => YNDK[:yes],
				:completed_on => Chronic.parse('tomorrow'))
			#	sometimes this fails during test:coverage?
			assert object.errors.on(:completed_on)
			assert_match(/future/,
				object.errors.on(:completed_on))
		end
	end


	test "should require ineligible_reason if is_eligible == :no" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_eligible => YNDK[:no])
			assert object.errors.on(:ineligible_reason)
		end
	end

	test "should require ineligible_reason_specify if " <<
			"ineligible_reason == other" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:ineligible_reason => 
				IneligibleReason['other'] )
			assert object.errors.on(:ineligible_reason_specify)
		end
	end

	test "should require reason_not_chosen if is_chosen == :no" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_chosen => YNDK[:no])
			assert object.errors.on(:reason_not_chosen)
		end
	end


	test "should require refusal_reason if consented == :no" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => YNDK[:no])
			assert object.errors.on(:refusal_reason)
		end
	end

	test "should NOT ALLOW refusal_reason if consented == nil" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => nil,
				:refusal_reason => Factory(:refusal_reason))
			assert object.errors.on(:refusal_reason)
		end
	end

	test "should NOT ALLOW refusal_reason if consented == :dk" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => YNDK[:dk],
				:refusal_reason => Factory(:refusal_reason))
			assert object.errors.on(:refusal_reason)
		end
	end

	test "should NOT ALLOW refusal_reason if consented == :yes" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => YNDK[:yes],
				:refusal_reason => Factory(:refusal_reason))
			assert object.errors.on(:refusal_reason)
		end
	end




	test "should require other_refusal_reason if " <<
			"refusal_reason == other" do
		assert_difference('Enrollment.count',0) do
			object = create_object(
				:refusal_reason => RefusalReason['other'] )
			assert object.errors.on(:other_refusal_reason)
		end
	end

	test "should NOT ALLOW other_refusal_reason if " <<
			"refusal_reason != other" do
		assert_difference('Enrollment.count',0) do
			object = create_object(
				:refusal_reason => Factory(:refusal_reason),
				:other_refusal_reason => 'asdfasdf' )
			assert object.errors.on(:other_refusal_reason)
		end
	end


	test "should require consented_on if consented == :yes" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => YNDK[:yes],
				:consented_on => nil)
			assert object.errors.on(:consented_on)
		end
	end

	test "should require consented_on if consented == :no" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => YNDK[:no],
				:consented_on => nil)
			assert object.errors.on(:consented_on)
		end
	end

	test "should NOT ALLOW consented_on if consented == :dk" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => YNDK[:dk],
				:consented_on => Date.today)
			assert object.errors.on(:consented_on)
		end
	end

	test "should NOT ALLOW consented_on if consented == nil" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => nil,
				:consented_on => Date.today)
			assert object.errors.on(:consented_on)
		end
	end


	test "should require terminated_reason if " <<
			"terminated_participation == :yes" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:terminated_participation => YNDK[:yes])
			assert object.errors.on(:terminated_reason)
		end
	end


	test "should require completed_on if is_complete == :yes" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_complete => YNDK[:yes])
			assert object.errors.on(:completed_on)
		end
	end

	test "should NOT ALLOW completed_on if is_complete == :no" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_complete => YNDK[:no],
				:completed_on => Date.today)
			assert object.errors.on(:completed_on)
		end
	end

	test "should NOT ALLOW completed_on if is_complete == :dk" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_complete => YNDK[:dk],
				:completed_on => Date.today)
			assert object.errors.on(:completed_on)
		end
	end

	test "should NOT ALLOW completed_on if is_complete == nil" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:is_complete => nil,
				:completed_on => Date.today)
			assert object.errors.on(:completed_on)
		end
	end


	test "should NOT ALLOW document_version_id if consented == nil" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => nil,
				:document_version => Factory(:document_version) )
			assert object.errors.on(:document_version)
		end
	end

	test "should NOT ALLOW document_version_id if consented == :dk" do
		assert_difference('Enrollment.count',0) do
			object = create_object(:consented => YNDK[:dk],
				:document_version => Factory(:document_version) )
			assert object.errors.on(:document_version)
		end
	end

	test "should allow document_version_id if consented == :yes" do
		assert_difference('Enrollment.count',1) do
			object = create_object(:consented => YNDK[:yes],
				:document_version => Factory(:document_version) )
		end
	end

	test "should allow document_version_id if consented == :no" do
		assert_difference('Enrollment.count',1) do
			object = create_object(:consented => YNDK[:no],
				:refusal_reason   => Factory(:refusal_reason),
				:document_version => Factory(:document_version) )
		end
	end



	test "should create operational event when enrollment complete" do
		object = create_object(
			:completed_on => nil,
			:is_complete => YNDK[:no])
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			object.update_attributes(
				:completed_on => past_date,
				:is_complete => YNDK[:yes])
		end
		oe = OperationalEvent.last
		assert_equal 'complete', oe.operational_event_type.code
		assert_equal past_date,  oe.occurred_on
		assert_equal object.subject_id, oe.enrollment.subject_id
	end

	test "should create operational event when enrollment complete UNSET" do
		past_date = Chronic.parse('Jan 15 2003').to_date
		object = nil
		assert_difference('OperationalEvent.count',1) do
			object = create_object(
				:completed_on => past_date,
				:is_complete => YNDK[:yes])
		end
		assert_difference('OperationalEvent.count',1) do
			object.update_attributes(
				:is_complete => YNDK[:no],
				:completed_on => nil)
		end
		oe = OperationalEvent.last
		assert_equal 'reopened', oe.operational_event_type.code
		assert_equal Date.today, oe.occurred_on
		assert_equal object.subject_id, oe.enrollment.subject_id
	end

protected

	def create_object(options = {})
		record = Factory.build(:enrollment,options)
		record.save
		record
	end

end
