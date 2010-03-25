#	Require 'ucb_cas' here rather than in config/environment.rb 
#	allows for UCB::CAS in all caps.  I think that this is a 
#	violation of a couple rails conventions.
require 'ucb_cas'	

class ApplicationController < ActionController::Base
	helper :all # include all helpers, all the time
	include Authentication  #	shows up twice in RDoc !?!?
	include UCB::CAS        #	won't show up in RDoc !?!?

	protect_from_forgery # See ActionController::RequestForgeryProtection for details

	# Scrub sensitive parameters from your log
	# filter_parameter_logging :password

protected

	#	redirections is called from the Aegis plugin.
	#	Actually from my extension of the Aegis plugin.
	#	This is a method that returns a hash containing
	#	permissions used in the before_filters as keys
	#	containing another hash with redirect_to and 
	#	message keys for special redirection.  By default,
	#	my plugin will redirect to root_path on failure
	#	and the flash error will be the before_filter.
	def redirections
#			@@redirections ||= HashWithIndifferentAccess.new({
#	#			:view_calendar => {},
#	#			:deputize => {},
#	#			:not_be_user => {},
#	#			:view_packages => {},
#	#			:maintain_pages => {},
#	#			:view_user => {},
#	#			:view_users => {},
#	#			:not_be_user => {},
#				:view_permissions => {
#					:message => "Go away",
#					:redirect_to => "http://cnn.com"
#				}
#			})
	end

	def block_all_access
		access_denied("That route is no longer available")
	end

end
