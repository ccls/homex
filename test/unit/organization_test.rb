require File.dirname(__FILE__) + '/../test_helper'

class OrganizationTest < ActiveSupport::TestCase

	test "should create organization" do
		assert_difference 'Organization.count' do
			organization = create_organization
			assert !organization.new_record?, 
				"#{organization.errors.full_messages.to_sentence}"
		end
	end

	test "should require name" do
		assert_no_difference 'Organization.count' do
			organization = create_organization(:name => nil)
			assert organization.errors.on(:name)
		end
	end

	test "should require 4 char name" do
		assert_no_difference 'Organization.count' do
			organization = create_organization(:name => 'Hey')
			assert organization.errors.on(:name)
		end
	end

	test "should require unique name" do
		org = create_organization
		assert_no_difference 'Organization.count' do
			organization = create_organization(:name => org.name)
			assert organization.errors.on(:name)
		end
	end

	test "new incoming_transfer should have matching organization id" do
		organization = create_organization
		transfer = organization.incoming_transfers.build
		assert_equal organization.id, transfer.to_organization_id
	end

	test "new outgoing_transfer should have matching organization id" do
		organization = create_organization
		transfer = organization.outgoing_transfers.build
		assert_equal organization.id, transfer.from_organization_id
	end

	test "should have many incoming_transfers" do
		organization = create_organization
		assert_equal 0, organization.reload.incoming_transfers.length
		organization.incoming_transfers << Factory(:transfer, 
			:to_organization_id => organization.id )
		assert_equal 1, organization.reload.incoming_transfers.length
		organization.incoming_transfers << Factory(:transfer, 
			:to_organization_id => organization.id )
		assert_equal 2, organization.reload.incoming_transfers.length
	end

	test "should have many outgoing_transfers" do
		organization = create_organization
		assert_equal 0, organization.reload.outgoing_transfers.length
		organization.outgoing_transfers << Factory(:transfer, 
			:from_organization_id => organization.id )
		assert_equal 1, organization.reload.outgoing_transfers.length
		organization.outgoing_transfers << Factory(:transfer, 
			:from_organization_id => organization.id )
		assert_equal 2, organization.reload.outgoing_transfers.length
	end

	test "should have many aliquots" do
		organization = create_organization
		assert_equal 0, organization.reload.aliquots.length
		assert_equal 0, organization.reload.aliquots_count
		organization.aliquots << Factory(:aliquot, 
			:owner_id => organization.id )
		assert_equal 1, organization.reload.aliquots.length
		assert_equal 1, organization.reload.aliquots_count
		organization.aliquots << Factory(:aliquot, 
			:owner_id => organization.id )
		assert_equal 2, organization.reload.aliquots.length
		assert_equal 2, organization.reload.aliquots_count
	end

	test "should have many samples" do
#		somehow

#		flunk samples

#	TODO
		pending

	end

protected

	def create_organization(options = {})
		record = Factory.build(:organization,options)
		record.save
		record
	end

end
