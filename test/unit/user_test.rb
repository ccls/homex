require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

	test "should create user" do
		assert_difference 'User.count' do
			user = create_user
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should ignore administrator attribute" do
		assert_difference 'User.count' do
			user = create_user	#	setting the attribute in a factory actually works so ...
			user.update_attributes(:administrator => true)
			assert !user.is_admin?
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create administrator" do
		assert_difference 'User.count' do
			user = create_user
			user.administrator = true
			user.save
			assert user.is_admin?
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should require uid" do
		assert_no_difference 'User.count' do
			u = create_user(:uid => '')
			assert_match "can't be blank", u.errors.on(:uid)
			assert u.errors.on(:uid)
		end
	end

	test "should require unique uid" do
		user = create_user
		assert_no_difference 'User.count' do
			u = create_user(:uid => user.uid)
			assert_match "has already been taken", u.errors.on(:uid)
			assert u.errors.on(:uid)
		end
	end

	test "should create and update user by uid" do
		assert_difference 'User.count' do
			user = User.find_create_and_update_by_uid('012345')
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should find and update user by uid" do
		create_user(:uid => '012345')
		assert_no_difference 'User.count' do
			user = User.find_create_and_update_by_uid('012345')
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

protected

	#
	#	This method is used so that an invalid user produces errors
	#	rather than raises exceptions which will cause the tests to fail.
	#
	def create_user(options = {})
		record = Factory.build(:user,options)
		record.save
		record
	end
	
end
