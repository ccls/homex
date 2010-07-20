require File.dirname(__FILE__) + '/../test_helper'

class TransferTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:aliquot)
	assert_requires_valid_associations(:organization,
		:as => :from_organization)
	assert_requires_valid_associations(:organization,
		:as => :to_organization)
	assert_should_initially_belong_to(:aliquot)
	assert_should_initially_belong_to(:to_organization,
		:class_name => 'Organization')
	assert_should_initially_belong_to(:from_organization,
		:class_name => 'Organization')

	test "should create transfer" do
		assert_difference 'Transfer.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:transfer,options)
		record.save
		record
	end

end
