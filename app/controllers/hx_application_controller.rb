class HxApplicationController < ApplicationController

	before_filter :may_view_home_exposures_required

	layout 'home_exposure'

protected

	def valid_hx_subject_id_required
		validate_hx_subject_id(params[:subject_id])
	end

	def valid_id_for_hx_subject_required
		validate_hx_subject_id(params[:id])
	end

	def validate_hx_subject_id(id,redirect=nil)
		if !id.blank? and Subject.exists?(id)
			@subject = Subject.find(id)
		else
			access_denied("Valid subject id required!", 
				redirect || hx_subjects_path)
		end
	end

#	Don't know if I'll use this or not.
#
#	def get_hx_subjects
#		hx = Project.find_by_code('HomeExposures')
#		if params[:commit] && params[:commit] == 'download'
#			params[:paginate] = false
#		end
#		#   params[:projects] ||= {}
#		#   params[:projects][hx.id] ||= {}
#		#   @subjects = Subject.search(params)
#		@subjects = hx.subjects.search(params)
#	end

end
