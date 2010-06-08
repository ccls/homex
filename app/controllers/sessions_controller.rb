class SessionsController < ApplicationController	#:nodoc:

	def destroy
#		self.current_user.forget_me if logged_in?
#		cookies.delete :auth_token
#
#	for the moment, cal login is required to logout 
#	so will never do the "else"
#
		calnetuid = session[:calnetuid]
		reset_session
		CASClient::Frameworks::Rails::Filter.logout(self)
	end

end
