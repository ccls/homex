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
	#	Also works for those that follow conventions
	#		may_view_user_required
	#	In the above case, @user must be defined first.
	#	Also, targets must be distinctly singular. (or NOT plural)
#	def method_missing(symb)
#	def method_missing_with_aegis_permissions(symb,*args)
#		method_name = symb.to_s
#		if method_name =~ /^may_(.+)_required$/ && Permissions.exists?($1)
#			permission = $1
#			verb,target = permission.split(/_/,2)
#
#			#	using target words where singular == plural won't work here
#			if !target.blank? && target == target.singularize
#				unless current_user.try("may_#{permission}?", instance_variable_get("@#{target}") )
#					access_denied( "You don't have permission to #{verb} this #{target}." )
#				end
#			else
#				#	current_user may be nil so must use try and NOT send
#				unless current_user.try("may_#{permission}?")
#					send( :access_denied, "You don't have permission to #{permission.gsub(/_/,' ')}." )
##					access_denied( "You don't have permission to #{permission.gsub(/_/,' ')}." )
##flash[:error] = "You don't have permission to #{permission.gsub(/_/,' ')}."
##send(:redirect_to_referer_or_default,root_path)
#				end
#			end
#		else
##			super
#			method_missing_without_aegis_permissions(symb, *args)
#		end
#	end
#	alias_method_chain :method_missing, :aegis_permissions

#	move this to aegis_extension plugin after replace access_denied calls

end
