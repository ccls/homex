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

	#	['superuser','administrator']
#	alias_method :may_view_samples?,     :may_administrate?
#	alias_method :may_view_sample_kits?, :may_administrate?
#	alias_method :may_maintain_races?,   :may_administrate?
	alias_method :may_edit_subjects?,    :may_administrate?
#	alias_method :may_create_survey_invitations?, :may_administrate?
	alias_method :may_take_surveys?,              :may_administrate?

	#	['superuser','administrator','editor']
	alias_method :may_edit_addresses?,      :may_edit?
	alias_method :may_edit_enrollments?,    :may_edit?
#	alias_method :may_edit_home_page_pics?, :may_edit?

#	#	['superuser','administrator','editor','reader']
#	alias_method :may_view_calendar?,       :may_read?
#	alias_method :may_view_dust_kits?,      :may_read?
#	alias_method :may_view_home_exposures?, :may_read?		#	<----
#	alias_method :may_view_packages?,       :may_read?
#	alias_method :may_view_projects?,       :may_read?
#	alias_method :may_view_responses?,      :may_read?
#	alias_method :may_view_subjects?,       :may_read?

end
