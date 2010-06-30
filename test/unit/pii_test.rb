require File.dirname(__FILE__) + '/../test_helper'

class PiiTest < ActiveSupport::TestCase

	test "should create pii" do
		assert_difference 'Pii.count' do
			pii = create_pii
			assert !pii.new_record?, 
				"#{pii.errors.full_messages.to_sentence}"
		end
	end

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
	test "should require subject_id on update" do
		assert_difference 'Pii.count', 1 do
			pii = create_pii
			pii.reload.update_attributes(:first_name => "New First Name")
			assert pii.errors.on(:subject)
		end
	end

	test "should require unique subject_id" do
		subject = Factory(:subject)
		create_pii(:subject => subject)
		assert_difference( 'Pii.count', 0 ) do
			pii = create_pii(:subject => subject)
			assert pii.errors.on(:subject_id)
		end
	end

	test "should require state_id_no" do
		assert_no_difference 'Pii.count' do
			pii = create_pii(:state_id_no => nil)
			assert pii.errors.on(:state_id_no)
		end
	end

	test "should require unique state_id_no" do
		p = create_pii
		assert_no_difference 'Pii.count' do
			pii = create_pii(:state_id_no => p.state_id_no)
			assert pii.errors.on(:state_id_no)
		end
	end

	test "should require unique email" do
		p = create_pii
		assert_no_difference 'Pii.count' do
			pii = create_pii(:email => p.email)
			assert pii.errors.on(:email)
		end
	end

	test "should require dob" do
		assert_no_difference 'Pii.count' do
			pii = create_pii(:dob => nil)
			assert pii.errors.on(:dob)
		end
	end

	test "should allow multiple blank email" do
		p = create_pii(:email => '  ')
		assert_difference('Pii.count',1) do
			pii = create_pii(:email => ' ')
		end
	end

	test "should belong to subject" do
		pii = create_pii
		assert_nil pii.subject
		pii.subject = Factory(:subject)
		assert_not_nil pii.subject
	end

	test "should require properly formated email address" do
		pending
	end

protected

	def create_pii(options = {})
		record = Factory.build(:pii,options)
		record.save
		record
	end

end
