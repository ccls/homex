require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

	test "should create user" do
		assert_difference 'User.count' do
			user = create_user
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
			assert !user.may_moderate?      #	aegis check
			assert !user.may_administrate?  #	aegis check
		end
	end

	test "should create moderator" do
		assert_difference 'User.count' do
			user = create_user
			user.update_attribute(:role_name, 'moderator')
			assert !user.is_admin?
			assert user.may_moderate?     #	aegis check
			assert !user.may_administrate? #	aegis check
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create administrator" do
		assert_difference 'User.count' do
			user = create_user
			user.deputize
			assert user.is_admin?
			assert user.may_moderate?     #	aegis check
			assert user.may_administrate? #	aegis check
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

	test "should require that role_name NOT be mass assignable" do
		assert_difference 'User.count' do
			u = create_user
			u.update_attributes({:role_name => 'administrator'})
			#	the default role is NOT administrator so this should be true
			assert_not_equal u.role_name, 'administrator'
		end
	end

	test "should require role_name be a defined role in permissions" do
		assert_no_difference 'User.count' do
			#	role_name is mass assignable in the Factory context (which seems wrong)
			u = create_user(:role_name => 'my_fake_role_name')
			assert_match "is not included in the list", u.errors.on(:role_name)
			assert u.errors.on(:role_name)
		end
	end

	test "should get deputies in alphabetic order by sn" do
		new_users = [
			create_user(:sn => "baseball", :role_name => "administrator"),
			create_user(:sn => "apple", :role_name => "administrator"),
			create_user(:sn => "pie", :role_name => "administrator")
		]
		deputies = User.deputies
		assert_equal deputies[0], new_users[1]
		assert_equal deputies[1], new_users[0]
		assert_equal deputies[2], new_users[2]
	end



	test "should create and update user by uid" do
		assert_difference 'User.count' do
			user = User.find_create_and_update_by_uid('012345')
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create and update user by a valid uid" do
		assert_difference 'User.count' do
			user = User.find_create_and_update_by_uid('859908')
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
