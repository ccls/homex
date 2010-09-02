class HxApplicationController < ApplicationController

#	before_filter :remember_or_recall_sort_order

#	before_filter :may_view_home_exposures_required
	before_filter :may_view_required

	# from ucb_ccls_engine_controller.rb 
	#	Its interesting that the skip needs to be here
	#	and not in the ApplicationController
	skip_before_filter :build_menu_js

#	layout 'home_exposure'

protected

	def valid_hx_subject_id_required
		validate_hx_subject_id(params[:subject_id])
	end

	def valid_id_for_hx_subject_required
		validate_hx_subject_id(params[:id])
	end

	#	I intended to check that the subject is actually
	#	enrolled in HomeExposures, but haven't yet.
	def validate_hx_subject_id(id,redirect=nil)
		if !id.blank? and Subject.exists?(id)
			@subject = Subject.find(id)
		else
			access_denied("Valid subject id required!", 
				redirect || subjects_path)
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

	def remember_or_recall_sort_order
		%w( dir order ).map(&:to_sym).each do |param|
			if params[param].blank? && !session[param].blank?
				params[param] = session[param]	#	recall
			elsif !params[param].blank?
				session[param] = params[param]	#	remember
			end
		end
	end

end
