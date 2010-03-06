class User < ActiveRecord::Base
	default_scope :order => :sn

	has_role :default => :user  #, :name_accessor => :role_name
	validates_role_name

	validates_presence_of   :uid
	validates_uniqueness_of :uid
	attr_accessible :sn, :displayname, :mail, :telephonenumber

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

	def is_admin?
		self.role_name == "administrator"
	end

	def deputize
		self.update_attribute( :role_name, 'administrator' )
	end

	def undeputize
		self.update_attribute( :role_name, 'user' )
	end

end
