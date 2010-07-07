#require 'auth_by_authlogic'
require 'auth_by_ucb_cas'
require 'authorization'
class ApplicationController < ActionController::Base
	before_filter :login_required

	include SslRequirement

	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	protect_from_forgery 

	# Scrub sensitive parameters from your log
	filter_parameter_logging :password

	helper_method :current_user, :logged_in?

protected	#	private #	(does it matter which or if neither?)

#	def no_current_user_required
#		logged_in? &&
#			access_denied("You must be logged out to do that",root_path)
#	end

	#	Does nothing in testing as https just causes errors.
	#	Gotta figure this thing out.
	def ssl_required?
		#	Force https everywhere (that doesn't have ssl_allowed set)
		true
	end

	def logged_in?
		!current_user.nil?
	end

	def redirect_to_referer_or_default(default)
		redirect_to( session[:refer_to] || 
			request.env["HTTP_REFERER"] || default )
		session[:refer_to] = nil
	end

	#	Flash error message and redirect
	def access_denied( 
			message="You don't have permission to complete that action.", 
			default=root_path )
		session[:return_to] = request.request_uri
		flash[:error] = message
		redirect_to default
	end

	#	This is a method that returns a hash containing
	#	permissions used in the before_filters as keys
	#	containing another hash with redirect_to and 
	#	message keys for special redirection.  By default,
	#	it will redirect to root_path on failure
	#	and the flash error will be a humanized
	#	version of the before_filter's name.
	def redirections
		@redirections ||= HashWithIndifferentAccess.new({
			:not_be_user => {
				:redirect_to => user_path(current_user)
			}
		})
	end

	def block_all_access
		access_denied("That route is no longer available")
	end

end
