class UsersController < ApplicationController

#	before_filter :cas_gateway_filter
#	before_filter :admin_required, :only => :index
	before_filter :may_view_users_required, :only => :index
	before_filter :admin_or_self_required, :only => :show

	def show
		@user = User.find(params[:id])
	end

	def index
		@users = User.all(:order => :sn)
	end

protected

	def admin_or_self_required
		#	Note: current_user.id is an Integer and params hash values are always strings
		unless ( current_user.id == params[:id].to_i || current_user.is_admin? ) 
			access_denied( "Cannot view this user!", root_path )
		end
	end

	def may_view_users_required
		unless current_user.may_view_users?
			access_denied("You are not allowed to view all users!")
		end
	end

end
