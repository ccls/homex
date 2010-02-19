require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < ActiveSupport::TestCase

	test "should create address" do
		assert_difference 'Address.count' do
			address = create_address
			assert !address.new_record?, "#{address.errors.full_messages.to_sentence}"
		end
	end

	test "should have many addresses_subjects" do

#	change the name!
#		flunk

	end

	test "should have many interview_events" do

#		flunk

	end

protected

	def create_address(options = {})
		record = Factory.build(:address,options)
		record.save
		record
	end

end
