require File.dirname(__FILE__) + '/../test_helper'

class AddressTypeTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:addresses)

	test "should create address_type" do
		assert_difference 'AddressType.count' do
			address_type = create_address_type
			assert !address_type.new_record?, 
				"#{address_type.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'AddressType.count' do
			address_type = create_address_type(:code => nil)
			assert address_type.errors.on(:code)
		end
	end

	test "should require 4 char code" do
		assert_no_difference 'AddressType.count' do
			address_type = create_address_type(:code => 'Hey')
			assert address_type.errors.on(:code)
		end
	end

	test "should require unique code" do
		a = create_address_type
		assert_no_difference 'AddressType.count' do
			address_type = create_address_type(:code => a.code)
			assert address_type.errors.on(:code)
		end
	end

protected

	def create_address_type(options = {})
		record = Factory.build(:address_type,options)
		record.save
		record
	end
	alias_method :create_object, :create_address_type

end
