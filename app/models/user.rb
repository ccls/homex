#	== requires
#	*	uid (unique)
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
class User < ActiveRecord::Base

	ucb_authenticated

#	def may_administrate?(*args)
#		self.role_names.include?('administrator')
#	end
#	alias_method :may_view_permissions?,        :may_administrate?
#	alias_method :may_create_user_invitations?, :may_administrate?
#	alias_method :may_view_users?,              :may_administrate?
#	alias_method :may_assign_roles?,            :may_administrate?
#	alias_method :administrator?,               :may_administrate?
#	alias_method :is_administrator?,            :may_administrate?
#	alias_method :may_edit_subjects?,           :may_administrate?
#
#	def may_moderate?
#		(self.role_names & ['administrator','moderator']).length > 0
#	end
#	alias_method :moderator?, :may_moderate?
#
#	def editor?
#		(self.role_names & ['administrator','editor']).length > 0
#	end
#	alias_method :may_maintain_pages?,      :editor?
#	alias_method :may_view_home_page_pics?, :editor?
#
#	def may_view_calendar?(*args)
#		(self.role_names & ['administrator','editor','employee']).length > 0
#	end
#	alias_method :may_view_packages?,       :may_view_calendar?
#	alias_method :may_view_subjects?,       :may_view_calendar?
#	alias_method :may_view_dust_kits?,      :may_view_calendar?
#	alias_method :may_view_home_exposures?, :may_view_calendar?
#	alias_method :may_edit_addresses?,      :may_view_calendar?
#	alias_method :may_edit_enrollments?,    :may_view_calendar?
#
#	def employee?
#		(self.role_names & ['administrator','employee']).length > 0
#	end
#	alias_method :may_view_responses?,            :employee?
#	alias_method :may_take_surveys?,              :employee?
#	alias_method :may_view_study_events?,         :employee?
#	alias_method :may_create_survey_invitations?, :employee?
#
#	def may_view_user?(user=nil)
#		self.is_user?(user) || self.is_administrator?
#	end
#
#	def is_user?(user=nil)
#		!user.nil? && self == user
#	end
#	alias_method :may_be_user?, :is_user?

end
