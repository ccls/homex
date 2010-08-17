class ContactsController < HxApplicationController

	before_filter :may_edit_required
	before_filter :valid_hx_subject_id_required

	def index
	end

end
