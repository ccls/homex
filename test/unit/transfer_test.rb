require File.dirname(__FILE__) + '/../test_helper'

class TransferTest < ActiveSupport::TestCase

	test "should create transfer" do
		assert_difference 'Transfer.count' do
			transfer = create_transfer
			assert !transfer.new_record?, 
				"#{transfer.errors.full_messages.to_sentence}"
		end
	end

	test "should require valid from_organization" do
		assert_no_difference 'Transfer.count' do
			transfer = create_transfer(:from_organization_id => 0)
			assert transfer.errors.on(:from_organization_id)
		end
	end

	test "should require valid to_organization" do
		assert_no_difference 'Transfer.count' do
			transfer = create_transfer(:to_organization_id => 0)
			assert transfer.errors.on(:to_organization_id)
		end
	end

	test "should require valid aliquot" do
		assert_no_difference 'Transfer.count' do
			transfer = create_transfer(:aliquot_id => 0)
			assert transfer.errors.on(:aliquot_id)
		end
	end

	test "should require from_organization" do
		assert_no_difference 'Transfer.count' do
			transfer = create_transfer(:from_organization_id => nil)
			assert transfer.errors.on(:from_organization_id)
		end
	end

	test "should require to_organization" do
		assert_no_difference 'Transfer.count' do
			transfer = create_transfer(:to_organization_id => nil)
			assert transfer.errors.on(:to_organization_id)
		end
	end

	test "should require aliquot" do
		assert_no_difference 'Transfer.count' do
			transfer = create_transfer(:aliquot_id => nil)
			assert transfer.errors.on(:aliquot_id)
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

end
