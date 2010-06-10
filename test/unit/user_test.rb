require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

	test "should create user" do
		assert_difference 'User.count' do
			user = create_user
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
			assert !user.may_moderate?     #	aegis check
			assert !user.may_administrate? #	aegis check
		end
	end

	test "should create employee" do
		assert_difference 'User.count' do
			user = create_user
			user.update_attribute(:role_name, 'employee')
			assert  user.employee?
			assert !user.administrator?
			assert !user.may_moderate?      #	aegis check
			assert !user.may_administrate? #	aegis check
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create editor" do
		assert_difference 'User.count' do
			user = create_user
			user.update_attribute(:role_name, 'editor')
			assert  user.editor?
			assert !user.administrator?
			assert !user.may_moderate?      #	aegis check
			assert !user.may_administrate? #	aegis check
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create moderator" do
		assert_difference 'User.count' do
			user = create_user
			user.update_attribute(:role_name, 'moderator')
			assert !user.administrator?
			assert user.may_moderate?      #	aegis check
			assert !user.may_administrate? #	aegis check
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create administrator" do
		assert_difference 'User.count' do
			user = create_user
			user.update_attribute(:role_name, 'administrator')
			assert user.administrator?
			assert user.may_moderate?     #	aegis check
			assert user.may_administrate? #	aegis check
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should require uid" do
		assert_no_difference 'User.count' do
			u = create_user(:uid => nil)
			assert u.errors.on(:uid)
		end
	end

	test "should require unique uid" do
		user = create_user
		assert_no_difference 'User.count' do
			u = create_user(:uid => user.uid)
			assert u.errors.on(:uid)
		end
	end

#	We are using UCB CAS for authentication so this is unused.
#	If Authlogic or other is reused, uncomment all this.
#
#	test "should require password matching confirmation" do
#		assert_no_difference 'User.count' do
#			u = create_user(
#				:password              => 'alpha',
#				:password_confirmation => 'beta')
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password_confirmation" do
#		assert_no_difference 'User.count' do
#			u = create_user(:password_confirmation => nil)
#			assert u.errors.on(:password_confirmation)
#		end
#	end
#
#	test "should require password" do
#		assert_no_difference 'User.count' do
#			u = create_user(:password => nil)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password with at least 8 chars" do
#		invalid_password = "1nV@l!d"
#		assert_no_difference 'User.count' do
#			u = create_user(:password => invalid_password,
#				:password_confirmation => invalid_password)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password with symbol" do
#		invalid_password = Factory.attributes_for(:user
#			)[:password].gsub(/\W/,'a')
#		assert_no_difference 'User.count' do
#			u = create_user(:password => invalid_password,
#				:password_confirmation => invalid_password)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password with number" do
#		invalid_password = Factory.attributes_for(:user
#			)[:password].gsub(/\d/,'a')
#		assert_no_difference 'User.count' do
#			u = create_user(:password => invalid_password,
#				:password_confirmation => invalid_password)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password with lowercase letter" do
#		invalid_password = Factory.attributes_for(:user)[:password].upcase
#		assert_no_difference 'User.count' do
#			u = create_user(:password => invalid_password,
#				:password_confirmation => invalid_password)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password with uppercase letter" do
#		invalid_password = Factory.attributes_for(:user)[:password].downcase
#		assert_no_difference 'User.count' do
#			u = create_user(:password => invalid_password,
#				:password_confirmation => invalid_password)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require properly formated email address" do
#		assert_no_difference 'User.count' do
#			u = create_user(:email => 'blah blah blah')
#			assert u.errors.on(:email)
#		end
#	end
#
#	test "should require email" do
#		assert_no_difference 'User.count' do
#			u = create_user(:email => nil)
#			assert u.errors.on(:email)
#		end
#	end
#
#	test "should require unique email" do
#		user = create_user
#		assert_no_difference 'User.count' do
#			u = create_user(:email => user.email)
#			assert u.errors.on(:email)
#		end
#	end
#
#	test "should require username" do
#		assert_no_difference 'User.count' do
#			u = create_user(:username => nil)
#			assert u.errors.on(:username)
#		end
#	end
#
#	test "should require unique username" do
#		user = create_user
#		assert_no_difference 'User.count' do
#			u = create_user(:username => user.username)
#			assert u.errors.on(:username)
#		end
#	end
#
#	test "should require unique perishable token" do
#		user = create_user
#		user.reload
#		assert_not_nil user.perishable_token
#		Authlogic::Random.stubs(:friendly_token).returns(user.perishable_token)
#		User.stubs(:find_by_perishable_token).returns(nil)
#		assert_difference('User.count',0) do
#			#	Just build the user
#			u = Factory.build(:user)
#			#	Then force the perishable token
#			u.reset_perishable_token
#			#	Then save which will validate and raise a
#			#	validation error.
#			assert_not_nil u.perishable_token
#			u.save
#			assert u.errors.on(:perishable_token)
#		end
#	end
#
#	test "should require unique persistence token" do
#		user = create_user
#		user.reload
#		assert_not_nil user.persistence_token
#		Authlogic::Random.stubs(:hex_token).returns(user.persistence_token)
#		User.stubs(:find_by_persistence_token).returns(nil)
#		assert_difference('User.count',0) do
#			u = create_user
#			assert_not_nil u.persistence_token
#			assert u.errors.on(:persistence_token)
#		end
#	end
#
#	test "should respond to extended methods" do
#		user = create_user
#		assert user.respond_to?(:reset_persistence_token_with_uniqueness)
#		assert user.respond_to?(:reset_perishable_token_with_uniqueness)
#		assert user.respond_to?(:reset_persistence_token_without_uniqueness)
#		assert user.respond_to?(:reset_perishable_token_without_uniqueness)
#	end

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

	test "should return non-nil email" do
		user = create_user
#		assert_nil user.mail
		assert_not_nil user.email
	end

	test "should return non-nil gravatar_url" do
		user = create_user
		assert_not_nil user.gravatar_url
	end

	test "should NOT mass assign role_name" do
		user = create_user
		all_role_names = Permissions.find_all_role_names.collect(&:to_s)
		other_roles = all_role_names - [user.role_name]
		other_roles.each do |role_name|
			user.update_attributes({:role_name => role_name})
			assert_not_equal user.reload.role_name, role_name
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
