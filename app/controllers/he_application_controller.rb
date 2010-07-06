class HeApplicationController < ApplicationController

	before_filter :may_view_home_exposures_required

	layout 'home_exposure'

protected

	def valid_he_subject_id_required
		if !params[:subject_id].blank? and Subject.exists?(params[:subject_id])
			@subject = Subject.find(params[:subject_id])
		else
			access_denied("Valid subject id required!", he_subjects_path)
		end
	end

	def valid_id_for_he_subject_required
		if !params[:id].blank? and Subject.exists?(params[:id])
			@subject = Subject.find(params[:id])
		else
			access_denied("Valid subject id required!", he_subjects_path)
		end
	end

	def get_he_subjects
		he = Project.find_by_description('Home Exposure')
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		#   params[:projects] ||= {}
		#   params[:projects][he.id] ||= {}
		#   @subjects = Subject.search(params)
		@subjects = he.subjects.search(params)
	end

end
