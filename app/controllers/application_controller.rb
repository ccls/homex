class ApplicationController < ActionController::Base
	before_filter :login_required

	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	protect_from_forgery 

	# Scrub sensitive parameters from your log
	filter_parameter_logging :password

	helper_method :current_user, :logged_in?

protected	#	private #	(does it matter which or if neither?)
	
	def current_user_session
		@current_user_session ||= UserSession.find	
	end	
	
	def current_user	
		@current_user ||= current_user_session && current_user_session.record	
	end	

	def no_current_user_required
		if current_user
			flash[:error] = "You must be logged out to do that"
			redirect_to root_path
		end
	end

	def current_user_required
		unless current_user
			flash[:error] = "You must be logged in to do that"
			redirect_to login_path
		end
	end
#	alias_method :cas_filter,     :current_user_required
	alias_method :login_required, :current_user_required

	def logged_in?
		!current_user.nil?
	end

	def redirect_to_referer_or_default(default)
#		redirect_to(session[:refer_to] || default)
#	I don't quite know why the writer required that the developer set the :refer_to.
		redirect_to( session[:refer_to] || request.env["HTTP_REFERER"] || default )
		session[:refer_to] = nil
	end

	#	Flash error message and redirect
	def access_denied( message="You don't have permission to complete that action.", default=root_path )
#		store_referer
		flash[:error] = message
		redirect_to_referer_or_default( default )
	end

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
