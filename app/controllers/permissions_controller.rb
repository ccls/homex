class PermissionsController < ApplicationController	#:nodoc:

	before_filter :may_view_permissions_required

	#	how to expire a non-db related cache???
	caches_action :index, :layout => false

end
