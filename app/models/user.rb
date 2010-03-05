#require 'aegis/has_role_hack'
class User < ActiveRecord::Base
	default_scope :order => :sn
	####	begin aegis permissions code
	#
	# The value of the role_name column MUST ALWAYS
	# be one of the roles defined in permission.rb
	# which I think is kinda stupid.  Mispellings, 
	# nil, blank all cause 
	# "RuntimeError: Undefined role: whatever-your-bad-role-was"
	# and there is no default so must add one.
	# This is what a new user would be.
	has_role :default => :user    #   , :name_accessor => :role_name
	# We cannot do both attr_protected and attr_accessible
	# but we MUSTN'T allow the mass assignment of :role_name
	# attr_protected :role_name
	#
	validates_role_name
	# Inspires the following warning 
	# DEPRECATION WARNING: ActiveRecord::Errors.default_error_messages has been deprecated
	# but I've hacked a fix in lib/aegis/has_roles_hack.rb
	#	add reported issue on github.
	#
	####	end aegis permissions code

	validates_presence_of   :uid
	validates_uniqueness_of :uid
	attr_accessible :sn, :displayname, :mail, :telephonenumber

	def self.find_create_and_update_by_uid(uid)
		user = User.find_or_create_by_uid(uid)
		person = UCB::LDAP::Person.find_by_uid(uid) 
		#	since I'm not blindly copying these attributes, perhaps I should rename them.
		user.update_attributes!({
#			:displayname     => person.attributes[:displayname].first,
#			:mail            => person.attributes[:mail].first,
#			:telephonenumber => person.attributes[:telephonenumber].first
			:displayname     => person.displayname,		#	NOT array
			:sn              => person.sn.first,		#	array
			:mail            => person.mail.first,		#	Array
			:telephonenumber => person.telephonenumber.first	#	another array
		}) if person
		user
	end

	Permissions.find_all_role_names.each do |role_name|
		named_scope role_name.to_s.pluralize, :conditions => { 
			:role_name => role_name.to_s 
		}
	end

	named_scope :deputies, :conditions => { :role_name => "administrator" }

	def is_admin?
		#	using something so simple as an attribute to control such power is ill advised!
#		return self.administrator
		self.role_name == "administrator"
	end

	def deputize
#		self.update_attribute( :administrator, true )
		self.update_attribute( :role_name, 'administrator' )
	end

	def undeputize
#		self.update_attribute( :administrator, false )
		self.update_attribute( :role_name, 'user' )
	end

end
