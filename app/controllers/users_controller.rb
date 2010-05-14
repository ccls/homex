class UsersController < ApplicationController	#:nodoc:

	skip_before_filter :login_required, 
		:only => [:new, :create]

	before_filter :no_current_user_required, :only => [:new, :create]
	before_filter :id_required, :only => [:edit, :show, :update ]
	before_filter :may_view_user_required, :only => [:edit,:update,:show]
	before_filter :may_view_users_required, :only => :index

	def new	
		@user = User.new	
	end	

	def create	
		@user = User.new(params[:user])	
		#		if @user.save	
		#	don't login, just create user
		if @user.save_without_session_maintenance
			flash[:notice] = "Registration successful."	
			redirect_to login_url	
		else	
			flash[:error] = 'User creation failed'
			render :action => 'new'	
		end	
	end	

	def edit	
	end	
	 
	def update	
		if @user.update_attributes(params[:user])	
			flash[:notice] = "Successfully updated profile."	
			redirect_to root_url	
		else	
			flash[:error] = "Update failed"
			render :action => 'edit'	
		end	
	end 

	def show
		@roles = Permissions.find_all_roles.sort_by{|role| 
			role.options[:position]}.reverse
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

protected

	def id_required
		if !params[:id].blank? and User.exists?(params[:id])
			@user = User.find(params[:id])
		else
			access_denied("user id required!", users_path)
		end
	end

end
