class PackagesController < ApplicationController

	before_filter :may_view_packages_required

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
		package = Package.find(params[:id])
		package.update_status
		redirect_to_referer_or_default packages_path
	end

	def show
		@last_shipping_update = Package.last_updated
		@package = Package.find(params[:id])
	end

end
