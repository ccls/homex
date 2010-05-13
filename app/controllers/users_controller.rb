class UsersController < ApplicationController	#:nodoc:

	before_filter :id_required, :only => [ :show, :update ]
	before_filter :may_view_user_required, :only => :show
	before_filter :may_view_users_required, :only => :index
	before_filter :may_not_be_user_required, :only => :update

#
#	prep for using authlogic for authentication
#
#	before_filter :no_current_user_required, :only => [:new, :create]
#	before_filter :current_user_required, :only => [:edit,:update,:index,:show]
#
#	def new	
#		@user = User.new	
#	end	
#
#	def create	
#		@user = User.new(params[:user])	
#		#		if @user.save	
#		#	don't login, just create user
#		if @user.save_without_session_maintenance
#			flash[:notice] = "Registration successful."	
#			redirect_to login_url	
#		else	
#			render :action => 'new'	
#		end	
#	end	
#
#	def edit	
#	end	
#	 
#	def update	
#		if @user.update_attributes(params[:user])	
#			flash[:notice] = "Successfully updated profile."	
#			redirect_to root_url	
#		else	
#			render :action => 'edit'	
#		end	
#	end 



	def show
		@roles = Permissions.find_all_roles.sort_by{|role| role.options[:position]}.reverse
	end

	def index
		conditions = {}
		if Permissions.find_role_by_name(params[:role_name])
			conditions[:role_name] = params[:role_name]
		elsif !params[:role_name].blank?
			flash[:error] = "No such role '#{params[:role_name]}'"
		end
		@users = User.all( :conditions => conditions )
	end

	def update
		@user.role_name = params[:role_name]
		@user.save!
		flash[:notice] = 'User was successfully updated.'
#		redirect_to @user
	rescue ActiveRecord::RecordInvalid
#		show
#		flash.now[:error] = 'User update failed.'
		flash[:error] = 'User update failed.'
#		render :show
	ensure
		redirect_to @user
	end

protected

	def id_required
		if !params[:id].blank? and User.exists?(params[:id])
			@user = User.find(params[:id])
		else
			access_denied("user id required!", users_path)
		end
	end

end
