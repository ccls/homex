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

end
