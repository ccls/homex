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
	#	Actually, they are handled in method_missing
	#		so the methods never really exist.


	#	So far all of these blocks are only used to create
	#	methods that return true or false if the user
	#	is an administrator.  Seems like overkill for now.


	#	There is no before filter style handling
	#	I'm thinking that each of these permission blocks
	#	could generate a method that could be used as a
	#	before filter with a flash message and a redirect.
	#	Maybe I'll fork and do that.
	#	Possible for those may_*? without arguments,
	#	but those that take arguments will be a challenge.

	#
	#	FYI Tips:
	#		* method_missing also catches role_names
	#			ie. User.first.administrator?
	#		*	When using arguments for permissions, 
	#			the first MUST be for the calling user.
	#		*	permissions beginning with "crud_" are special
	#			and other may_* methods are created and 
	#			NOT may_crud_* 
	#			(create, read, update and destroy both singular and plural)
	#			( see lib/aegis/permissions.rb : add_split_crud_permission )
	#		* There is also some permission name parsing done
	#			that may modify the created names based on 
	#			singularity and plurality and word length which
	#			is understandable, but potentially incorrect.
	#			( /^([^_]+?)_(.+?)$/ ... (verb, target) )
	#			( see lib/aegis/permissions.rb : add_singularized_permission )
	#		*	Creating a plural permission will also create
	#			a singular one.
	#		*	CRUD verbs like "view" will be "normalized" to
	#			other verbs like "read" in the permission_names
	#			but still work as if they weren't.
	#

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


	#	this will also create singular maintain_page permission (no arguments)
	permission :maintain_pages do #	|current_user|
	end

#	:crud_addresses creates the following ...
#	:create_address, :create_addresses, :destroy_address, :destroy_addresses, 
#	:read_address, :read_addresses, :update_address, :update_addresses
#	I don't know exactly how it handles arguments though?
#	Arguments are optional.  Nil if not passed so use that in logic.
	permission :crud_addresses do |current_user,address|
#puts address.inspect
	end

	#	this will be normalized to "read_users" and a singular
	#		read_user permission will also be created.
	permission :view_users do #	|current_user|
	end
	permission :view_user do |current_user,user|
		allow :user do
			current_user == user
		end
	end

	#	this will be normalized to "read_user" and override above
#	permission :view_user do |calling_user,target_user|
#		deny :everyone
#		allow :everyone do
#puts calling_user.inspect
#puts target_user.inspect
#			false
#		end
#	end

	#	This one is awkward and the natural english is wrong.
	#	Really should be MUST_NOT_be_self
	#		current_user.may_not_be_self?(target_user)
	#	surprised that the negatives aren't created.
#	permission :not_be_self do |current_user, target_user|
#		allow :everyone do
#			!target_user.blank? && current_user != target_user
#		end
#	end

	permission :be_user do |current_user,target_user|
		#	MUST deny everyone first (includes admin)
		#	so that negative works.  "be user" is more of
		#	an absolute so an admin isn't someone else.
		deny :everyone
#		allow :user, :moderator, :administrator do 
		allow :everyone do
			current_user == target_user
		end
	end

end
