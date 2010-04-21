#	== requires
#	*	valid role_name
#	*	uid
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
class User < ActiveRecord::Base
	default_scope :order => :sn

	##
	#	:singleton-method: has_role
	#	Associate #User with #Permissions and set the default 
	#	role of a user to :user

	has_role :default => :user  #, :name_accessor => :role_name
	validates_role_name
	gravatar :email, :rating => 'PG'

	validates_presence_of   :uid
	validates_uniqueness_of :uid
	attr_accessible :sn, :displayname, :mail, :telephonenumber

	#	Find or Create a user from a given uid, and then 
	#	proceed to update the user's information from the 
	#	UCB::LDAP::Person.find_by_uid(uid) response.
	#	
	#	Returns: user
	def self.find_create_and_update_by_uid(uid)
		user = User.find_or_create_by_uid(uid)
		person = UCB::LDAP::Person.find_by_uid(uid) 
		user.update_attributes!({
			:displayname     => person.displayname,
			:sn              => person.sn.first,
			:mail            => person.mail.first,
			:telephonenumber => person.telephonenumber.first
		}) if person
#
#	what happened if person is NIL?
# hack attempt?
# can a user be in CAS and then not in LDAP?
#	Might want to handle this "else" condition
#	TODO
#
		user
	end

#	Permissions.find_all_role_names.each do |role_name|
#		named_scope role_name.to_s.pluralize, :conditions => { 
#			:role_name => role_name.to_s 
#		}
#	end
#
#	named_scope :deputies, :conditions => { :role_name => "administrator" }

	#	Checks if role_name is 'administrator'
	#	Returns: boolean
#	def is_admin?
#		self.role_name == "administrator"
#	end

#	def is_employee?
#		%w( administrator employee ).include?( self.role_name )
#	end

#	#	Assigns role_name to 'administrator'
#	#	Returns: boolean
#	def deputize
#		self.update_attribute( :role_name, 'administrator' )
#	end

#	def undeputize
#		self.update_attribute( :role_name, 'user' )
#	end

	#	gravatar can't deal with a nil mail
	def email
		(self.mail.nil?)?'':self.mail
	end

	#	gravatar.url will include & that are not encoded to &amp;
	#	which works just fine, but technically is invalid html.
	def gravatar_url
		gravatar.url.split('&').join('&amp;')
	end

end
