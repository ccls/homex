require File.dirname(__FILE__) + '/../test_helper'

class OrganizationTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require(:code,:name)
	assert_should_require_unique(:code,:name)
	assert_should_belong_to(:person)
	assert_should_have_many(:hospitals,:patients)
	assert_should_have_many(:aliquots, 
		:foreign_key => :owner_id)
	assert_should_have_many(:incoming_transfers, 
		:class_name => 'Transfer',
		:foreign_key => :to_organization_id)
	assert_should_have_many(:outgoing_transfers, 
		:class_name => 'Transfer',
		:foreign_key => :from_organization_id)

#	test "should create organization" do
#		assert_difference( "#{model_name}.count", 1 ) do
#			organization = create_organization
#			assert !organization.new_record?, 
#				"#{organization.errors.full_messages.to_sentence}"
#		end
#	end

	test "should require 4 char code" do
		assert_difference( "#{model_name}.count", 0 ) do
			organization = create_organization(:code => 'Hey')
			assert organization.errors.on(:code)
		end
	end

	test "should require 4 char name" do
		assert_difference( "#{model_name}.count", 0 ) do
			organization = create_organization(:name => 'Hey')
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

	test "should have many samples" do
#		somehow

#		flunk samples

#	TODO

		#	this is unclear in my diagram
		pending

	end

	test "should return name as to_s" do
		organization = create_organization
		assert_equal organization.name, "#{organization}"
	end

end
