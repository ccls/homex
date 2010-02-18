require File.dirname(__FILE__) + '/../test_helper'

class OrganizationTest < ActiveSupport::TestCase

	test "should create organization" do
		assert_difference 'Organization.count' do
			organization = create_organization
			assert !organization.new_record?, "#{organization.errors.full_messages.to_sentence}"
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

protected

	def create_organization(options = {})
		record = Factory.build(:organization,options)
		record.save
		record
	end

end
