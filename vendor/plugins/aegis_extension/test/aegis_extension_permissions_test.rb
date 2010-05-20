require File.dirname(__FILE__) + '/test_helper'

class AegisExtensionRoleTest < ActiveSupport::TestCase

	def setup
		setup_db
	end

	def teardown
		teardown_db
	end

	test "valid_role? is true for valid role as string" do
		assert ::Permissions.valid_role?(:administrator)
	end

	test "valid_role? is true for valid role as symbol" do
		assert ::Permissions.valid_role?('administrator')
	end

	test "valid_role? is false for invalid role as string" do
		assert !::Permissions.valid_role?(:suffocator)
	end

	test "valid_role? is false for invalid role as symbol" do
		assert !::Permissions.valid_role?('suffocator')
	end

end
