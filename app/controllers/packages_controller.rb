class PackagesController < ApplicationController	#:nodoc:

	before_filter :may_view_packages_required
	before_filter :valid_package_id_required, 
		:except => [:new,:create,:index]
#		:only => [:edit,:update,:show,:destroy]

	def index
		@last_shipping_update = Package.last_updated
		@packages = Package.all
	end

	def new
		@package = Package.new
	end

	def create
		@package = Package.new(params[:package])
		@package.save!
		@package.update_status
		flash[:notice] = 'Package was successfully created.'
		redirect_to(packages_path)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the package"
		render :action => "new"
	end

	def update
		@package.update_status
		redirect_to_referer_or_default packages_path
	end

	def ship
		@package.update_attribute(:status,'Transit')
		redirect_to_referer_or_default packages_path
	end

	def deliver
		@package.update_attribute(:status,'Delivered')
		redirect_to_referer_or_default packages_path
	end

	def show
		@last_shipping_update = Package.last_updated
	end

	def destroy
		@package.destroy
		redirect_to packages_path
	end

protected

	def valid_package_id_required
		if !params[:id].blank? and Package.exists?(params[:id])
			@package = Package.find(params[:id])
		else
			access_denied("Valid package id required!", packages_path)
		end
	end

end
