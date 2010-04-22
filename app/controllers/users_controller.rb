class UsersController < ApplicationController	#:nodoc:

	before_filter :id_required, :only => [ :show, :update ]
	before_filter :may_view_user_required, :only => :show
	before_filter :may_view_users_required, :only => :index
	before_filter :may_not_be_user_required, :only => :update

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
