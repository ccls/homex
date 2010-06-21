#	== requires
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
class User < ActiveRecord::Base

#	We are using UCB CAS for authentication so this is unused.
#	If Authlogic or other is reused, uncomment all this.
#
#	#	by default, expects a username or login attribute
#	#	which I didn't have and caused a bit of a headache!
#	#	Also automatically logs newly created user in
#	#	behind the scenes which caused testing headaches.
#	#	Set this to false to remove this "feature."
#	acts_as_authentic do |c|
#		#	This can be a pain in testing so disabled.
#		#	Creating objects via Factory with associated users 
#		#	results in them being autmatically logged in.
#		c.maintain_sessions = false
#	end
#
#	default_scope :order => :username
#
#	validates_length_of :password, :minimum => 8, 
#		:if => :password_changed?
#
#	validates_format_of :password,
#		:with => Regexp.new(
#			'(?=.*[a-z])' <<
#			'(?=.*[A-Z])' <<
#			'(?=.*\d)' <<
#			# !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
#			# '(?=.*[\x21-\x2F\x3A-\x40\x5B-\x60\x7B-\x7E])' 
#			#	this probably includes control chars
#			'(?=.*\W)' ), 
#		:message => 'requires at least one lowercase and one uppercase ' <<
#			'letter, one number and one special character',
#		:if => :password_changed?


	validates_presence_of :uid
	validates_uniqueness_of :uid

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
			:mail            => person.mail.first || '',
			:telephonenumber => person.telephonenumber.first
		})
#
#	seems to work fine without the if
#	must've been a testing thing as I now have a stub
#
#		}) if person
#
#	what happened if person is NIL?
# hack attempt?
# can a user be in CAS and then not in LDAP?
#	Might want to handle this "else" condition
#	TODO
#
#	rescue
		user
	end

	ROLES = %w( administrator moderator employee editor )
	has_and_belongs_to_many :roles, :uniq => true

	#	gravatar can't deal with a nil email
#	gravatar :email, :rating => 'PG'
	gravatar :mail, :rating => 'PG'

#	#	role_name CANNOT be mass-assignable!
#	attr_protected :role_name

	#	gravatar.url will include & that are not encoded to &amp;
	#	which works just fine, but technically is invalid html.
	def gravatar_url
#		gravatar.url.split('&').join('&amp;')
		gravatar.url.gsub(/&/,'&amp;')
	end

	def role_names
		roles.collect(&:name).uniq
	end

	def deputize
		roles << Role.find_or_create_by_name('administrator')
	end

	def may_administrate?(*args)
		self.role_names.include?('administrator')
#		['administrator'].include?(self.role_name)
	end
#	alias_method :may_deputize?, :may_administrate?
	alias_method :may_view_permissions?, :may_administrate?
	alias_method :may_create_user_invitations?, :may_administrate?
	alias_method :may_view_users?, :may_administrate?
#	alias_method :may_crud_addresses?, :may_administrate?
	alias_method :may_assign_roles?, :may_administrate?
	alias_method :administrator?, :may_administrate?

	def may_moderate?
		(self.role_names & ['administrator','moderator']).length > 0
#		['administrator','moderator'].include?(self.role_name)
	end
	alias_method :moderator?, :may_moderate?

	def employee?
		(self.role_names & ['administrator','employee']).length > 0
#		['administrator','employee'].include?(self.role_name)
	end

	def editor?
		(self.role_names & ['administrator','editor']).length > 0
#		['administrator','editor'].include?(self.role_name)
	end

	def may_maintain_pages?(*args)
		(self.role_names & ['administrator','editor']).length > 0
#		['administrator','editor'].include?(self.role_name)
	end
	alias_method :may_view_home_page_pics?, :may_maintain_pages?

	def may_view_calendar?(*args)
		(self.role_names & ['administrator','editor','employee']).length > 0
#		['administrator','editor','employee'].include?(self.role_name)
	end
	alias_method :may_view_packages?, :may_view_calendar?
	alias_method :may_view_subjects?, :may_view_calendar?
	alias_method :may_view_dust_kits?, :may_view_calendar?

	def may_view_responses?(*args)
		(self.role_names & ['administrator','employee']).length > 0
#		['administrator','employee'].include?(self.role_name)
	end
	alias_method :may_take_surveys?, :may_view_responses?
	alias_method :may_view_study_events?, :may_view_responses?
	alias_method :may_create_survey_invitations?, :may_view_responses?

	def may_view_user?(user=nil)
		( (self.role_names & ['administrator']).length > 0 ) || ( !user.nil? && self == user )
#		['administrator'].include?(self.role_name) || ( !user.nil? && self == user )
	end

	def may_be_user?(user=nil)
		!user.nil? && self == user
	end

#	Role.all.each do |role|
#		named_scope role.name.to_sym,
#			:joins => [:roles],
#			:conditions => ["roles.name = '#{role.name}'"]
#	end

end
