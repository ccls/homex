require File.dirname(__FILE__) + '/../test_helper'

class TransferTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:from_organization,
		:to_organization, :aliquot)

	test "should create transfer" do
		assert_difference 'Transfer.count' do
			transfer = create_transfer
			assert !transfer.new_record?, 
				"#{transfer.errors.full_messages.to_sentence}"
		end
	end

	test "should belong to from_organization" do
		transfer = create_transfer
		assert_not_nil transfer.from_organization
		assert transfer.from_organization.is_a?(Organization)
	end

	test "should belong to to_organization" do
		transfer = create_transfer
		assert_not_nil transfer.to_organization
		assert transfer.to_organization.is_a?(Organization)
	end

	test "should belong to aliquot" do
		transfer = create_transfer
		assert_not_nil transfer.aliquot
	end

protected

	def create_transfer(options = {})
		record = Factory.build(:transfer,options)
		record.save
		record
	end
	alias_method :create_object, :create_transfer

end
