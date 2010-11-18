class Followup::GiftCardsController < ApplicationController

	resourceful

#	def index
#		record_or_recall_sort_order
#		if params[:commit] && params[:commit] == 'download'
#			params[:paginate] = false
#		end
#		@subjects = Subject.for_hx_followup(params)
#		if params[:commit] && params[:commit] == 'download'
#			params[:format] = 'csv'
#			headers["Content-disposition"] = "attachment; " <<
#				"filename=subjects_#{Time.now.to_s(:filename)}.csv" 
#			render :template => "subjects/index"
#		end
#		@gift_cards = GiftCard.
#	end

protected

	def get_all
		@gift_cards = GiftCard.search(params)
	end

end
