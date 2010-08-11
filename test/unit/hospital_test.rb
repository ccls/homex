require File.dirname(__FILE__) + '/../test_helper'

class HospitalTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_belong_to(:organization)

	test "should create hospital" do
		assert_difference 'Hospital.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:hospital,options)
		record.save
		record
	end

end
