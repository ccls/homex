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

	alias_method :may_view_samples?,     :may_administrate?
	alias_method :may_view_sample_kits?, :may_administrate?
	alias_method :may_maintain_races?,   :may_administrate?
	alias_method :may_edit_subjects?,    :may_administrate?

	def may_view_calendar?(*args)
		(self.role_names & 
			['superuser','administrator','editor','reader']
		).length > 0 
	end 
	alias_method :may_view_packages?,       :may_view_calendar?
	alias_method :may_view_subjects?,       :may_view_calendar?
	alias_method :may_view_dust_kits?,      :may_view_calendar?
	alias_method :may_view_home_exposures?, :may_view_calendar?
	alias_method :may_edit_addresses?,      :may_view_calendar?
	alias_method :may_edit_enrollments?,    :may_view_calendar?
	alias_method :may_view_responses?,            :may_read?
	alias_method :may_take_surveys?,              :may_read?
	alias_method :may_view_study_events?,         :may_read?
	alias_method :may_create_survey_invitations?, :may_read?

alias_method :may_view_home_page_pics?, :may_edit?


end
