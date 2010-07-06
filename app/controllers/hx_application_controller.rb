class HxApplicationController < ApplicationController

	before_filter :may_view_home_exposures_required

	layout 'home_exposure'

protected

	def valid_hx_subject_id_required
#		if !params[:subject_id].blank? and Subject.exists?(params[:subject_id])
#			@subject = Subject.find(params[:subject_id])
#		else
#			access_denied("Valid subject id required!", hx_subjects_path)
#		end
		validate_hx_subject_id(params[:subject_id])
	end

	def valid_id_for_hx_subject_required
#		if !params[:id].blank? and Subject.exists?(params[:id])
#			@subject = Subject.find(params[:id])
#		else
#			access_denied("Valid subject id required!", hx_subjects_path)
#		end
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

	def get_hx_subjects
		hx = Project.find_by_description('Home Exposure')
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		#   params[:projects] ||= {}
		#   params[:projects][hx.id] ||= {}
		#   @subjects = Subject.search(params)
		@subjects = hx.subjects.search(params)
	end

end
