require File.dirname(__FILE__) + '/../test_helper'

class AddressTypeTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:addresses)
	assert_should_require(:code)
	assert_should_require_unique(:code)

	test "should create address_type" do
		assert_difference 'AddressType.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char code" do
		assert_no_difference 'AddressType.count' do
			object = create_object(:code => 'Hey')
			assert object.errors.on(:code)
		end
	end

	test "should return code as to_s" do
		object = create_object
		assert_equal object.code, "#{object}"
	end

	test "should find by code with []" do
		object = AddressType['residence']
		assert object.is_a?(AddressType)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(AddressType::NotFound) {
#			object = AddressType['idonotexist']
#		}
#	end

protected

	def create_object(options = {})
		record = Factory.build(:address_type,options)
		record.save
		record
	end

end
