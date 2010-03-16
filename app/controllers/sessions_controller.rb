class SessionsController < ApplicationController	#:nodoc:

	def destroy
#		self.current_user.forget_me if logged_in?
#		cookies.delete :auth_token
		reset_session
		CASClient::Frameworks::Rails::Filter.logout(self)
#		flash[:notice] = "You have been logged out."
#		redirect_to root_path		
	end

end
