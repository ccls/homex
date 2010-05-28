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

protected

#	#	Yes, this is ridiculously unlikely, but this attribute
#	#	is validated as unique, but no effort is made to ensure
#	#	that it actually is unique.  This number is HUGE,
#	#	but if a random number was chosen and was the same
#	#	as another, the error would not be the user's fault.
#	def reset_persistence_token_with_uniqueness
#		begin
#			reset_persistence_token_without_uniqueness
#		end while ( self.class.find_by_persistence_token(self.persistence_token) )
#	end
#	alias_method_chain :reset_persistence_token, :uniqueness
#
#	#	same as the persistence token, however ....
#	#	The perishable_token is created AFTER validation and 
#	#	before save, which mean its uniqueness is never 
#	#	validated which is really stupid.  This method
#	#	will ensure it is unique but won't raise errors.
#	def reset_perishable_token_with_uniqueness
#		begin
#			reset_perishable_token_without_uniqueness
#		end while ( self.class.find_by_perishable_token(self.perishable_token) )
#	end
#	alias_method_chain :reset_perishable_token, :uniqueness
#
#	#	Why ...
#	#	before_save :reset_perishable_token, 
#	#		:unless => :disable_perishable_token_maintenance?
#	#	and not before_validate?
#	#	before_save means that the uniqueness isn't validated
#	#	unless the token is manually changed.

end
