require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < ActiveSupport::TestCase

	test "should create role" do
		assert_difference('Role.count',1) do
			role = create_role
			assert !role.new_record?, "#{role.errors.full_messages.to_sentence}"
		end 
	end

	test "should require name" do
		assert_difference('Role.count',0) do
			role = create_role(:name => nil)
			assert role.errors.on(:name)
		end 
	end

	test "should require unique name" do
		r = create_role
		assert_difference('Role.count',0) do
			role = create_role(:name => r.name)
			assert role.errors.on(:name)
		end 
	end

	test "should act as list" do
		#	gotta be a relative test as there are already
		#	roles (unless I destroy them)
		assert_difference('Role.last.position',1) do
			create_role
		end
	end

	test "should respond to users" do
		role = create_role
		assert role.respond_to?(:users)
	end

protected

	def create_role(options = {})
		record = Factory.build(:role,options)
		record.save
		record
	end

end
