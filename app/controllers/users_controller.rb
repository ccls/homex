class UsersController < ApplicationController

	skip_before_filter :cas_filter			  # user does not need to be logged in to view these pages
#	skip_before_filter CASClient::Frameworks::Rails::Filter
	before_filter :cas_gateway_filter

	def show
		@user = User.find(params[:id])
	end

	def index
		@users = User.all(:order => :sn)
	end

end
