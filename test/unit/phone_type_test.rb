require File.dirname(__FILE__) + '/../test_helper'

class PhoneTypeTest < ActiveSupport::TestCase

	assert_should_act_as_list
#	assert_should_have_many(:subjects)
#	assert_should_require(:code,:description)
#	assert_should_require_unique(:code,:description)
	assert_should_require(:code)
	assert_should_require_unique(:code)

	test "should create phone_type" do
		assert_difference 'PhoneType.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:phone_type,options)
		record.save
		record
	end

end
