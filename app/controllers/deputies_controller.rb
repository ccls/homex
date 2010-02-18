class DeputiesController < ApplicationController

	before_filter :may_deputize_required
	before_filter :id_required, :except => :index
	before_filter :not_self_required, :except => :index

	def index
		@users = User.deputies
		render :template => 'users/index'
	end

	def create
		@user.deputize
		redirect_to_referer_or_default( users_path )
	end

	def destroy
		@user.undeputize
		redirect_to_referer_or_default( users_path )
	end

protected

	def id_required
		if !params[:id].blank? and User.exists?(params[:id])
			@user = User.find(params[:id])
		else
			access_denied("user id required!", users_path)
		end
	end

	def not_self_required
		( @user == current_user ) and access_denied( "Cannot undeputize self!", users_path )
	end
	
end
