#	Requires:
#	* valid role_name
#	* uid
#
#	Accessible attributes:
#	* sn
#	* displayname
#	* mail
#	* telephonenumber
class User < ActiveRecord::Base
	default_scope :order => :sn

	##
	#	Associate #User with #Permission and set the default 
	#	role of a user to :user

	has_role :default => :user  #, :name_accessor => :role_name
	validates_role_name

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
		user
	end

	Permissions.find_all_role_names.each do |role_name|
		named_scope role_name.to_s.pluralize, :conditions => { 
			:role_name => role_name.to_s 
		}
	end

	named_scope :deputies, :conditions => { :role_name => "administrator" }

	#	Checks if role_name is 'administrator'
	#	Returns: boolean
	def is_admin?
		self.role_name == "administrator"
	end

	#	Assigns role_name to 'administrator'
	#	Returns: boolean
	def deputize
		self.update_attribute( :role_name, 'administrator' )
	end

#	def undeputize
#		self.update_attribute( :role_name, 'user' )
#	end

end
