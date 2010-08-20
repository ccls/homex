require File.dirname(__FILE__) + '/../test_helper'

class AddressingTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:subject,:address)
#	assert_should_belong_to(:address)
#
#	polymorphic
#
#	assert_should_initially_belong_to(:addressable)
	assert_should_initially_belong_to(:subject,:address)


protected

	def create_object(options={})
		record = Factory.build(:addressing,options)
		record.save
		record
	end
	
end
