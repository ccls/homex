require File.dirname(__FILE__) + '/test_helper'

class AegisExtensionTest < ActiveSupport::TestCase

	def setup
		setup_db
	end

	def teardown
		teardown_db
	end

	test "user may create a post" do
		assert User.new.may_create_post?
	end

	test "user may view a post" do
		assert User.new.may_read_post?
		assert User.new.may_view_post?
	end

	test "post owner may edit post" do
		u = User.create
		u.posts << Post.create
		assert u.may_edit_post?(u.posts.first)
	end

	test "post owner may update post" do
		u = User.create
		u.posts << Post.create
		assert u.may_update_post?(u.posts.first)
	end

	test "post owner may destroy post" do
		u = User.create
		u.posts << Post.create
		assert u.may_destroy_post?(u.posts.first)
	end

	test "post non-owner may NOT edit post" do
		post = Post.create
		u = User.create
		assert !u.may_edit_post?(post)
	end

	test "post non-owner may NOT update post" do
		post = Post.create
		u = User.create
		assert !u.may_update_post?(post)
	end

	test "post non-owner may NOT destroy post" do
		post = Post.create
		u = User.create
		assert !u.may_destroy_post?(post)
	end

	test "permission exists" do
		assert ::Permissions.exists?(:moderate)
		assert ::Permissions.exists?(:administrate)
		assert ::Permissions.exists?(:create_post)
		assert ::Permissions.exists?(:update_post)
		assert ::Permissions.exists?(:destroy_post)
	end

	test "permission_names includes permissions" do
		assert ::Permissions.permission_names.include?(:moderate)
		assert ::Permissions.permission_names.include?(:administrate)
		assert ::Permissions.permission_names.include?(:create_post)
		assert ::Permissions.permission_names.include?(:update_post)
		assert ::Permissions.permission_names.include?(:destroy_post)
	end

	test "roles respond to options" do
		::Permissions.find_all_roles.each do |role|
			assert role.respond_to?(:name)
			assert role.respond_to?(:options)
			assert role.options.keys.include?(:position)
			assert role.options[:position] > 0
		end
	end

end
