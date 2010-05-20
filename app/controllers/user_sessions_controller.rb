class UserSessionsController < ApplicationController

	skip_before_filter :login_required, :except => [:destroy]
	before_filter :no_current_user_required, :only => [:new,:create]

	def new
		@user_session = UserSession.new
	end

	def create	
		@user_session = UserSession.new(params[:user_session])	
		if @user_session.save	
			flash[:notice] = "Successfully logged in."	
			redirect_to session[:aegis_return_to] || 
				session[:return_to] || root_url	
			session[:aegis_return_to] = nil
			session[:return_to] = nil
		else	
			#	The save will add errors to the object if login
			#	fails.  These errors will be shown on the login
			#	page which is bad practice as it gives a would-be
			#	hacker assistance in valid user names.
			@user_session.errors.clear
			flash.now[:error] = "Login Failed."
			render :action => 'new'	
		end	
	end	

	def destroy	
		@user_session = UserSession.find	
		@user_session.destroy	
		flash[:notice] = "Successfully logged out."	
		redirect_to root_url	
	end	

end
