class Followup::GiftCardsController < ApplicationController

	resourceful :update_redirect => :update_redirect_path

	def index
		record_or_recall_sort_order
#		if params[:commit] && params[:commit] == 'download'
#			params[:paginate] = false
#		end
#		@study_subjects = StudySubject.for_hx_followup(params)
#		if params[:commit] && params[:commit] == 'download'
#			params[:format] = 'csv'
#			headers["Content-disposition"] = "attachment; " <<
#				"filename=study_subjects_#{Time.now.to_s(:filename)}.csv" 
#			render :template => "study_subjects/index"
#		end
	end

	def edit
		@study_subjects  = []
		@study_subjects += [@gift_card.study_subject] unless @gift_card.study_subject.nil?
		@study_subjects += StudySubject.need_gift_card({:paginate => false})
	end

protected

	def get_all
		@gift_cards = GiftCard.search(params)
	end

	def update_redirect_path
		followup_gift_card_path(@gift_card)
	end

end
