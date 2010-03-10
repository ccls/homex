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

	def redirections
		@redirections ||= HashWithIndifferentAccess.new({
			:view_permissions => {
				:message => "Go away",
				:redirect_to => "http://cnn.com"
			}
		})
	end


end
