#	requiring it here rather than in config/environment.rb allows for UCB::CAS.
#	I think that this is a violation of rails naming conventions.
require 'ucb_cas'	

class ApplicationController < ActionController::Base
	helper :all # include all helpers, all the time
	include Authentication
	include UCB::CAS

	protect_from_forgery # See ActionController::RequestForgeryProtection for details

	# Scrub sensitive parameters from your log
	# filter_parameter_logging :password

protected

	#	This works when the permission does not take an argument.
	#		may_deputize_required
	#		may_maintain_pages_required
	#		may_view_users_required
	#	And as long as naming conventions are followed.
	def method_missing(symb)
		method_name = symb.to_s
		if method_name =~ /^may_(.+)_required$/ && Permissions.exists?($1)
			permission = $1
#			(verb, target) /^([^_]+?)_(.+?)$/
#	seems simpler to do this
			verb,target = permission.split(/_/,2)

			#	using target words where singular == plural won't work here
			#	use try because it is possible that target will be nil
			if target == target.try(:singularize)
				unless current_user.try("may_#{permission}?", instance_variable_get("@#{target}") )
					access_denied( "You don't have permission to #{verb} this #{target}." )
				end
			else
				#	current_user may be nil so must use try and NOT send
				unless current_user.try("may_#{permission}?")
					access_denied( "You don't have permission to #{permission.gsub(/_/,' ')}." )
				end
			end
		else
			super
		end
	end
	#	Would it be worth my time to make this work for things like ...
	#		may_view_user_ID_required
	#	and other permissions that take arguments that'll need parsed?

end
