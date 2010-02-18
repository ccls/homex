class UsersController < ApplicationController

	before_filter :id_required, :only => :show
	before_filter :may_view_user_required, :only => :show
	before_filter :may_view_users_required, :only => :index

	def show
	end

	def index
		@users = User.all(:order => :sn)
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
