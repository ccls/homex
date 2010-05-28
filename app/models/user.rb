#	== requires
#	*	valid role_name
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
class User < ActiveRecord::Base

	#	by default, expects a username or login attribute
	#	which I didn't have and caused a bit of a headache!
	#	Also automatically logs newly created user in
	#	behind the scenes which caused testing headaches.
	#	Set this to false to remove this "feature."
	acts_as_authentic do |c|
		c.maintain_sessions = false
	end

	default_scope :order => :username

	##
	#	:singleton-method: has_role
	#	Associate #User with #Permissions and set the default 
	#	role of a user to :user

	has_role :default => :user  #, :name_accessor => :role_name
	validates_role_name

	#	gravatar can't deal with a nil email
	gravatar :email, :rating => 'PG'

	#	role_name CANNOT be mass-assignable!
	attr_protected :role_name

	#	gravatar.url will include & that are not encoded to &amp;
	#	which works just fine, but technically is invalid html.
	def gravatar_url
#		gravatar.url.split('&').join('&amp;')
		gravatar.url.gsub(/&/,'&amp;')
	end

end
