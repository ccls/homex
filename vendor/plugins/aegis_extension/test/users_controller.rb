class UsersController < ApplicationController

	before_filter :id_required, :only => [ :edit, :update, :destroy, :show ]
#	before_filter :may_create_post_required, :only => [ :new, :create ]
#	before_filter :may_update_post_required, :only => [ :edit, :update ]
	before_filter :may_destroy_user_required, :only => [ :destroy ]
	before_filter :may_not_be_user_required, :only => [ :destroy ]

#	def new
#		render :text => ''
#	end

#	def create
#		render :text => ''
#	end

#	def edit
#		render :text => ''
#	end

#	def update
#		render :text => ''
#	end

	def destroy
		@user.destroy
		render :text => ''
	end

#	def show
#		render :text => ''
#	end

#	def index
#		render :text => ''
#	end

protected

	def id_required
		if !params[:id].blank? and User.exists?(params[:id])
			@user = User.find(params[:id])
		else
			flash[:error] = "Valid id required."
			redirect_to( users_path )
		end
	end

end
