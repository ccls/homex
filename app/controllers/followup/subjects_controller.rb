class Followup::SubjectsController < ApplicationController

	permissive

	before_filter :valid_id_for_hx_subject_required,
		:only => [:show,:edit]

	def index
		record_or_recall_sort_order
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		@subjects = Subject.for_hx_followup(params)
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "subjects/index"
		end
	end

	def show
#		@gift_cards = @subject.gift_cards
	end

end
