require File.dirname(__FILE__) + '/../test_helper'

class AddressingTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:subject)
	assert_should_initially_belong_to(:subject,:address)

	#
	# addressing uses accepts_attributes_for :address
	# so the addressing can't require address_id on create
	# or this test fails.
	#
	test "should require address_id on update" do
		assert_difference 'Addressing.count', 1 do
			object = create_object(:address_id => nil)
			object.reload.update_attributes(
				:created_at => Chronic.parse('yesterday'))
			assert object.errors.on(:address)
		end
	end

	test "should NOT require why_invalid if is_valid is nil" do
		assert_difference 'Addressing.count', 1 do
			object = create_object(:is_valid => nil)
		end
	end

	test "should NOT require why_invalid if is_valid is 1" do
		assert_difference 'Addressing.count', 1 do
			object = create_object(:is_valid => 1)
		end
	end

	test "should NOT require why_invalid if is_valid is 999" do
		assert_difference 'Addressing.count', 1 do
			object = create_object(:is_valid => 999)
		end
	end

	test "should require why_invalid if is_valid is 2" do
		assert_difference 'Addressing.count', 0 do
			object = create_object(:is_valid => 2)
			assert object.errors.on(:why_invalid)
		end
	end

	test "should NOT require how_verified if is_verified is false" do
		assert_difference 'Addressing.count', 1 do
			object = create_object(:is_verified => false)
		end
	end

	test "should require how_verified if is_verified is true" do
		assert_difference 'Addressing.count', 0 do
			object = create_object(:is_verified => true)
			assert object.errors.on(:how_verified)
		end
	end


	test "should NOT set verified_on if is_verified NOT changed to true" do
		object = create_object(:is_verified => false)
		assert_nil object.verified_on
	end


	test "should set verified_on if is_verified changed to true" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_on
	end

	test "should set verified_on to NIL if is_verified changed to false" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_on
		object.update_attributes(:is_verified => false)
		assert_nil object.verified_on
	end

	test "should NOT set verified_by_id if is_verified NOT changed to true" do
		object = create_object(:is_verified => false)
		assert_nil object.verified_by_id
	end

	test "should set verified_by_id to 0 if is_verified changed to true" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_by_id
		assert_equal object.verified_by_id, 0
	end

	test "should set verified_by_id to current_user.id if is_verified " <<
		"changed to true if current_user passed" do
		cu = admin_user
		object = create_object(:is_verified => true,
			:current_user => cu,
			:how_verified => "not a clue")
		assert_not_nil object.verified_by_id
		assert_equal object.verified_by_id, cu.id
	end

	test "should set verified_by_id to NIL if is_verified changed to false" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_by_id
		object.update_attributes(:is_verified => false)
		assert_nil object.verified_by_id
	end


	test "should only return current addressings" do
		create_object(:current_address => 1)
		create_object(:current_address => 2)
		create_object(:current_address => 999)
		objects = Addressing.current
		objects.each do |object|
			assert_equal 1, object.current_address
		end
	end

	test "should only return historic addressings" do
		create_object(:current_address => 1)
		create_object(:current_address => 2)
		create_object(:current_address => 999)
		objects = Addressing.historic
		objects.each do |object|
			assert_not_equal 1, object.current_address
		end
	end

protected

	def create_object(options={})
		record = Factory.build(:addressing,options)
		record.save
		record
	end
	
end
