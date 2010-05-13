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

#
#	prep for using authlogic for authentication
#
#	filter_parameter_logging :password
#
#	helper_method :current_user	

protected	#	private (does it matter which or if neither?)
	
#	def current_user_session
#		@current_user_session ||= UserSession.find	
#	end	
#	
#	def current_user	
#		@current_user ||= current_user_session && current_user_session.record	
#	end	
#
#	def no_current_user_required
#		if current_user
#			flash[:error] = "You must be logged out to do that"
#			redirect_to root_path
#		end
#	end
#
#	def current_user_required
#		unless current_user
#			flash[:error] = "You must be logged in to do that"
#			redirect_to login_path
#		end
#	end

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
