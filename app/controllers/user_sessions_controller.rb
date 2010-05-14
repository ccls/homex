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
			redirect_to root_url	
		else	
			flash[:error] = "Login Failed."
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
