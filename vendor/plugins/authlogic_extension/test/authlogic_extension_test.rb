require 'test_helper'

class AuthlogicExtensionTest < ActiveSupport::TestCase

	test "basic" do
		u = create_user

		assert_not_nil u.reload.perishable_token
		assert_not_nil u.reload.persistence_token

		assert u.respond_to?(:reset_persistence_token_with_uniqueness)
		assert u.respond_to?(:reset_perishable_token_with_uniqueness)
		assert u.respond_to?(:reset_persistence_token_without_uniqueness)
		assert u.respond_to?(:reset_perishable_token_without_uniqueness)

	end

#	test "a" do
#		create_user
#		puts "a:#{User.count}"
#	end
#
#	test "b" do
#		create_user
#		puts "b:#{User.count}"
#	end
#
#	test "c" do
#		create_user
#		puts "c:#{User.count}"
#	end
#
#	test "d" do
#		create_user
#		puts "d: #{User.count}"
#	end
#
#	test "e" do
#		create_user
#		puts "e:#{User.count}"
#	end

end
