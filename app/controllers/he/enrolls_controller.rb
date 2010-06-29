class He::EnrollsController < ApplicationController

	before_filter :may_view_subjects_required
	before_filter :get_subjects, :only => [:index,:send_letters]

	layout 'home_exposure'

	def index
		if params[:commit] && params[:commit] == 'download'
			flash.discard	#	discard possible flash from before redirects
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
		end
	end

	def send_letters
	end

	def update_select
		if params[:date].blank?
			flash[:notice] = "No date so nothing done"
		else
			date = Date.parse(params[:date].to_s)
			(params[:subjects]||[]).each do |id|
#	add before filter to ensure permission
#	also ensure an he subject
#				Subject.find(id).update_attribute(:some date, params[:date])
			end
			flash[:notice] = "Date set (not really, still deving)"
		end
		
		redirect_to he_enrolls_path(params.delete_keys!(
			:_method,:authenticity_token,:action,:subjects,:date
		))
	rescue Exception => e
		flash[:error] = e.message
		redirect_to send_letters_he_enrolls_path(params.delete_keys!(
			:_method,:authenticity_token,:action,:commit
		))
	end

protected

	def get_subjects
		he = Project.find_by_description('Home Exposure')
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
#		params[:projects] ||= {}
#		params[:projects][he.id] ||= {}
#		@subjects = Subject.search(params)
		@subjects = he.subjects.search(params)
	end

end
