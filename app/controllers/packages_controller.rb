class PackagesController < ApplicationController

	before_filter :may_view_packages_required

	def index
		@packages = Package.all
	end

end
