require File.dirname(__FILE__) + '/../test_helper'

class PiiTest < ActiveSupport::TestCase

	assert_should_belong_to(:subject)
	assert_should_require(:state_id_no,:dob)
	assert_should_require_unique(:state_id_no,:email)

	test "should create pii" do
		assert_difference 'Pii.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
	test "should require subject_id on update" do
		assert_difference 'Pii.count', 1 do
			object = create_object
			object.reload.update_attributes(:first_name => "New First Name")
			assert object.errors.on(:subject)
		end
	end

	test "should require unique subject_id" do
		subject = Factory(:subject)
		create_object(:subject => subject)
		assert_difference( 'Pii.count', 0 ) do
			object = create_object(:subject => subject)
			assert object.errors.on(:subject_id)
		end
	end

	test "should allow multiple blank email" do
		create_object(:email => '  ')
		assert_difference('Pii.count',1) do
			object = create_object(:email => ' ')
		end
	end

	test "should require properly formated email address" do
		pending
	end

protected

	def create_object(options = {})
		record = Factory.build(:pii,options)
		record.save
		record
	end

end
