class UsersController < ApplicationController

#	skip_before_filter :login_required, 
#		:only => [:new, :create]

#	before_filter :no_current_user_required, :only => [:new, :create]
#	before_filter :valid_invitation_required, :only => [:new,:create]
	before_filter :id_required, :only => [:edit, :show, :update ]
	before_filter :may_view_user_required, :only => [:edit,:update,:show]
	before_filter :may_view_users_required, :only => :index

#	We are using UCB CAS for authentication so this is unused.
#	If Authlogic or other is reused, uncomment all this.
#
#	def new	
#		@user = User.new	
#	end	
#
#	def create	
#		#	We want to create a user and invalidate the invitation.
#		#	NOT one or the other.  Must be both.
#		User.transaction do
#			@user = User.new(params[:user])	
#			@user.save!
#			@user_invitation.accepted_at = Time.now
#			@user_invitation.recipient_id = @user.id
#			@user_invitation.save!
#		end
#		flash[:notice] = "Registration successful."	
#		redirect_to login_url	
#	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
#		flash.now[:error] = 'User creation failed'
#		render :action => 'new'	
#	end	
#
#	def update	
#		@user.update_attributes!(params[:user])	
#		flash[:notice] = "Successfully updated profile."	
#		redirect_to root_url	
#	rescue ActiveRecord::RecordInvalid
#		flash.now[:error] = "Update failed"
#		render :action => 'edit'	
#	end 

	def show
#		@roles = User::ROLES
		@roles = Role.all
	end

	def index
		conditions = {}
		joins = []
#		if User::ROLES.include?(params[:role_name])
		if Role.all.collect(&:name).include?(params[:role_name])
			joins = [:roles]
			conditions = ["roles.name = '#{params[:role_name]}'"]
		elsif !params[:role_name].blank?
			flash[:error] = "No such role '#{params[:role_name]}'"
		end
		@users = User.all( :joins => joins, :conditions => conditions )
	end

protected

	def id_required
		if !params[:id].blank? and User.exists?(params[:id])
			@user = User.find(params[:id])
		else
			access_denied("user id required!", users_path)
		end
	end

#	def valid_invitation_required
#		if !params[:token].blank? && UserInvitation.exists?(
#			:token => params[:token],
#			:recipient_id => nil)
#			@user_invitation = UserInvitation.find_by_token(params[:token])
#		else
#			access_denied("Valid UserInvitation token required!")
#		end
#	end

end
