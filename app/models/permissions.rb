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

	role :user	#	default value for User.new

	role :moderator

	#	Always allow the administrators so don't have to include it
	#	in every permission block.
	role :administrator, :default_permission => :allow


	#	all of the following blocks create User methods
	#		#User.may_*? that return true or false period.
	#		#User.may_*! that return true or false and possible raise an error.


	permission :create_page do
	end
	permission :edit_page do
	end
	permission :destroy_page do
	end

end
