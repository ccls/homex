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

	test "should NOT require why_invalid if is_valid is :yes" do
		assert_difference 'Addressing.count', 1 do
			object = create_object(:is_valid => YNDK[:yes])
		end
	end

	test "should NOT require why_invalid if is_valid is :dk" do
		assert_difference 'Addressing.count', 1 do
			object = create_object(:is_valid => YNDK[:dk])
		end
	end

	test "should require why_invalid if is_valid is :no" do
		assert_difference 'Addressing.count', 0 do
			object = create_object(:is_valid => YNDK[:no])
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
		create_object(:current_address => YNDK[:yes])
		create_object(:current_address => YNDK[:no])
		create_object(:current_address => YNDK[:dk])
		objects = Addressing.current
		objects.each do |object|
			assert_equal 1, object.current_address
		end
	end

	test "should only return historic addressings" do
		create_object(:current_address => YNDK[:yes])
		create_object(:current_address => YNDK[:no])
		create_object(:current_address => YNDK[:dk])
		objects = Addressing.historic
		objects.each do |object|
			assert_not_equal 1, object.current_address
		end
	end




	test "should set is_eligible to false "<<
			"on create if state NOT 'CA'" do
		subject = create_hx_subject(:enrollment => {
			:is_eligible => YNDK[:yes] })
		assert_equal subject.hx_enrollment.is_eligible, YNDK[:yes]
		assert_difference('Addressing.count',1) {
		assert_difference('Address.count',1) {
			subject.addressings << Addressing.create(
				Factory.attributes_for(:addressing,
					:address_attributes => Factory.attributes_for(:address,
						:state => 'AZ',
						:address_type => AddressType.first 
			)	)	)
		} }
		assert_equal subject.hx_enrollment.is_eligible, YNDK[:no]
	end

	test "should set ineligible_reason to 'subject moved' "<<
			"on create if state NOT 'CA'" do
		subject = create_hx_subject(:enrollment => {
			:is_eligible => YNDK[:yes] })
		assert_nil   subject.hx_enrollment.ineligible_reason_id
		assert_equal subject.hx_enrollment.is_eligible, YNDK[:yes]
		assert_difference('Addressing.count',1) {
		assert_difference('Address.count',1) {
			subject.addressings << Addressing.create(
				Factory.attributes_for(:addressing,
					:address_attributes => Factory.attributes_for(:address,
						:state => 'AZ',
						:address_type => AddressType.first 
			)	)	)
		} }
		assert_not_nil subject.hx_enrollment.ineligible_reason_id
		assert_equal   subject.hx_enrollment.is_eligible, YNDK[:no]
	end

protected

	def create_object(options={})
		record = Factory.build(:addressing,options)
		record.save
		record
	end
	
end
