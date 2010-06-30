require File.dirname(__FILE__) + '/../test_helper'

class TransferTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:from_organization,
		:to_organization, :aliquot)
	assert_should_initially_belong_to(:aliquot,
		:from_organization,:to_organization)

	test "should create transfer" do
		assert_difference 'Transfer.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should belong to from_organization" do
		object = create_object
		assert_not_nil object.from_organization
		assert object.from_organization.is_a?(Organization)
	end

	test "should belong to to_organization" do
		object = create_object
		assert_not_nil object.to_organization
		assert object.to_organization.is_a?(Organization)
	end

protected

	def create_object(options = {})
		record = Factory.build(:transfer,options)
		record.save
		record
	end

end
