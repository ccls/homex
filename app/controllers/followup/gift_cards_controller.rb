class Followup::GiftCardsController < ApplicationController

#	FYI. Now that I've explicitly added the code here, it may not be 100% covered by testing.

	before_filter :may_create_gift_cards_required,
		:only => [:new,:create]
	before_filter :may_read_gift_cards_required,
		:only => [:show,:index]
	before_filter :may_update_gift_cards_required,
		:only => [:edit,:update]
	before_filter :may_destroy_gift_cards_required,
		:only => :destroy

	before_filter :valid_id_required, 
		:only => [:show,:edit,:update,:destroy]

	def index
		record_or_recall_sort_order
#	while I'd love to get rid of GiftCardSearch, it does handle sorting and stuff nicely
		@gift_cards = GiftCard.search(params)
	end

#	def new
#		@gift_card = GiftCard.new
#	end

#	def create
#		@gift_card = GiftCard.new(params[:gift_card])
#		@gift_card.save!
#		flash[:notice] = 'Success!'
#		redirect_to @gift_card
#	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
#		flash.now[:error] = "There was a problem creating " <<
#			"the gift card"
#		render :action => "new"
#	end 

	def edit
		@study_subjects  = []
		@study_subjects += [@gift_card.study_subject] unless @gift_card.study_subject.nil?
		@study_subjects += StudySubject.search( params.dup.deep_merge(
			:paginate => false,
			:projects => { Project['HomeExposures'].id =>{} },
			:search_gift_cards => true,
			:has_gift_card => false,
			:sample_outcome => 'complete',
			:interview_outcome => 'complete'
		))
	end

	def update
		@gift_card.update_attributes!(params[:gift_card])
		flash[:notice] = 'Success!'
		redirect_to followup_gift_card_path(@gift_card)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating " <<
			"the gift card"
		render :action => "edit"
	end

#	def destroy
#		@gift_card.destroy
#		redirect_to gift_cards_path
#	end

protected

	def valid_id_required
		if( !params[:id].blank? && GiftCard.exists?(params[:id]) )
			@gift_card = GiftCard.find(params[:id])
		else
			access_denied("Valid id required!", gift_cards_path)
		end
	end

end

__END__

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
		@study_subjects += StudySubject.search( params.dup.deep_merge(
			:paginate => false,
			:projects => { Project['HomeExposures'].id =>{} },
			:search_gift_cards => true,
			:has_gift_card => false,
			:sample_outcome => 'complete',
			:interview_outcome => 'complete'
		))
	end

protected

	def get_all
#	while I'd love to get rid of GiftCardSearch, it does handle sorting and stuff nicely
		@gift_cards = GiftCard.search(params)
	end

	def update_redirect_path
		followup_gift_card_path(@gift_card)
	end

end

