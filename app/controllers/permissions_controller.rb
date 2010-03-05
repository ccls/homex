class PermissionsController < ApplicationController

	before_filter :may_view_permissions_required

end
