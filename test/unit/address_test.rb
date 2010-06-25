require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < ActiveSupport::TestCase

	test "should create address" do
		assert_difference 'Address.count' do
			address = create_address
			assert !address.new_record?, 
				"#{address.errors.full_messages.to_sentence}"
		end
	end

	test "should have many residences" do
		address = create_address
		assert_equal 0, address.residences.length
		Factory(:residence, :address_id => address.id)
		assert_equal 1, address.reload.residences.length
		Factory(:residence, :address_id => address.id)
		assert_equal 2, address.reload.residences.length
	end

	test "should NOT destroy residences on destroy" do
		address = create_address
		Factory(:residence, :address_id => address.id)
		Factory(:residence, :address_id => address.id)
		assert_difference('Residence.count',0) {
		assert_difference('Address.count',-1) {
			address.destroy
		} }
	end

	test "should have many interview_events" do
		address = create_address
		assert_equal 0, address.interview_events.length
		Factory(:interview_event, :address_id => address.id)
		assert_equal 1, address.reload.interview_events.length
		Factory(:interview_event, :address_id => address.id)
		assert_equal 2, address.reload.interview_events.length
	end

	test "should belong to address_type" do
		address = create_address
		assert_nil address.address_type
		address.address_type = Factory(:address_type)
		assert_not_nil address.address_type
	end

protected

	def create_address(options = {})
		record = Factory.build(:address,options)
		record.save
		record
	end

end
