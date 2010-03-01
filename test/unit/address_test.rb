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

	test "should have many interview_events" do
		address = create_address
		assert_equal 0, address.interview_events.length
		Factory(:interview_event, :address_id => address.id)
		assert_equal 1, address.reload.interview_events.length
		Factory(:interview_event, :address_id => address.id)
		assert_equal 2, address.reload.interview_events.length
	end

protected

	def create_address(options = {})
		record = Factory.build(:address,options)
		record.save
		record
	end

end
