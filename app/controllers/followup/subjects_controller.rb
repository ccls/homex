class Followup::SubjectsController < ApplicationController

	permissive

	before_filter :valid_id_for_hx_subject_required,
		:only => [:show,:edit,:update]
	before_filter :valid_gift_card_required, :only => :update

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

	def edit
		@gift_cards  = []
		@gift_cards  = [@subject.hx_gift_card] unless @subject.hx_gift_card.nil?
		@gift_cards += GiftCard.find(:all,
			:conditions => {:study_subject_id => nil })
	end

	def update
		@gift_card.subject = @subject
		@gift_card.project = Project['HomeExposures']
		@gift_card.issued_on = params[:gift_card][:issued_on]
		@gift_card.save!
		flash[:notice] = 'Success!'
		redirect_to followup_subject_path(@subject)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating " <<
			"the subject"
		render :action => "edit"
	end

protected

	def valid_gift_card_required
#  Parameters: {"gift_card"=>{"id"=>"1", "issued_on"=>"11/23/2010"}, "authenticity_token"=>"rflVLW6tRQNHra1X3H25btqSM+MPamKhyOdaU4mUJKE=", "id"=>"17739"}

		if params[:gift_card] && 
			!params[:gift_card][:id].blank? &&
			GiftCard.exists?(params[:gift_card][:id])
			@gift_card = GiftCard.find(params[:gift_card][:id])
		else
			access_denied("Valid gift_card id required!", followup_subjects_path)
		end
	end

end
