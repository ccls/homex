class User < ActiveRecord::Base

	#	The value of the role_name column MUST ALWAYS
	#	be one of the roles defined in permission.rb
	#	which I think is kinda stupid.  Mispellings, 
	#	nil, blank all cause 
	#	"RuntimeError: Undefined role: whatever-your-bad-role-was"
	#	and there is no default so must add one.
	#	This is what a new user would be.
	has_role :default => :user	

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

	def is_admin?
		#	using something so simple as an attribute to control such power is ill advised!
		return self.administrator
	end

	def deputize
		self.update_attribute( :administrator, true )
	end

	def undeputize
		self.update_attribute( :administrator, false )
	end

end
