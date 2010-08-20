require File.dirname(__FILE__) + '/../test_helper'

class AddressingTest < ActiveSupport::TestCase

#	assert_requires_valid_associations(:subject,:address)
	assert_requires_valid_associations(:subject)
#	assert_should_belong_to(:address)
#
#	polymorphic
#
#	assert_should_initially_belong_to(:addressable)
	assert_should_initially_belong_to(:subject,:address)

	#
	# subject uses accepts_attributes_for :pii
	# so the pii can't require subject_id on create
	# or this test fails.
	#
	#
	# addressing uses accepts_attributes_for :address
	# so the addressing can't require address_id on create
	# or this test fails.
	#
	test "should require address_id on update" do
		assert_difference 'Addressing.count', 1 do
			object = create_object(:address_id => nil)
			object.reload.update_attributes(:is_valid => true)
			assert object.errors.on(:address)
		end
	end

protected

	def create_object(options={})
		record = Factory.build(:addressing,options)
		record.save
		record
	end
	
end
