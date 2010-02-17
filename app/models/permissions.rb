#	require 'aegis/has_role_hack'
#	User.has_role :default => :user
#	User.validates_role_name
class Permissions < Aegis::Permissions
	#
	#	This role seems useless as if the user is just a guest and not 
	#	a registered user, then there is no column to assign this value?
	#	role :guest
	#
	#	This role also seems useless as it is basically just saying
	#	that there is a user model and the value of role_name column
	#	is irrelevant?
	#	role :registered_user
	#


	#	The value of user.role_name MUST be one of these roles.
	#	This seems a bit restrictive.  If it is not and the user
	#	is submitted to one of these may_*? it will error.
	#	IMO, it should default to false or something.
	#	There is a validation for this



	role :user	#	default value for User.new

	#	This role serves no purpose as of yet
	role :moderator

	#	Always allow the administrators so don't have to include it
	#	in every permission block.
	role :administrator, :default_permission => :allow


	#	all of the following blocks create User methods
	#		#User.may_*? that return true or false period.
	#		#User.may_*! that return true or false and possible raise an error.


	#	So far all of these blocks are only used to create
	#	methods that return true or false if the user
	#	is an administrator.  Seems like overkill for now.


	#	This is really a catch all is-user-an-administrator permission.
	permission :administrate do
	end

	#	This is really a catch all is-user-an-administrator-or-moderator permission.
	permission :moderate do
		allow :moderator
	end

	permission :deputize do
	end

#	permission :deputize_user do |current_user,target_user|
#		allow :administrator do 
#			current_user != target_user
#		end
#	end

#	permission :create_page do |user,page|
#	end
#	permission :edit_page do |user,page|
#	end
#	permission :destroy_page do |user,page|
#	end
	permission :maintain_pages do |current_user|
	end

	permission :view_users do |current_user|
	end
#	permission :view_user do |current_user,user|
#		allow :user do
#			current_user == user
#		end
#	end

end
