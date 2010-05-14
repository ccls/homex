class UserRolesController < ApplicationController

	before_filter :id_required
	before_filter :may_not_be_user_required

	def update
		@user.role_name = params[:role_name]
		@user.save!
		flash[:notice] = 'User was successfully updated.'
	rescue ActiveRecord::RecordInvalid
		flash[:error] = 'User update failed.'
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
