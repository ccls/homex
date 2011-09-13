class Followup::StudySubjectsController < ApplicationController

	permissive

	before_filter :valid_id_for_hx_study_subject_required,
		:only => [:show,:edit,:update]
	before_filter :valid_gift_card_required, :only => :update

	def index
		record_or_recall_sort_order
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		@study_subjects = StudySubject.for_hx_followup(params)
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=study_subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "study_subjects/index"
		end
	end

	def show
	end

	def edit
		@gift_cards  = (@study_subject.hx_gift_card.nil?) ? [] : [@study_subject.hx_gift_card]
		@gift_cards += GiftCard.find(:all,
			:conditions => {:study_subject_id => nil })
	end

	def update
#		unless @study_subject.hx_gift_card.nil?
#	if the study_subject has a hx_gift_card and it is not the same one that 
#	is being updated, unassign the old one.
		if !@study_subject.hx_gift_card.nil? && @study_subject.hx_gift_card != @gift_card
#			old_hx_gift_card = @study_subject.hx_gift_card
# this doesn't simply assign the GC, it keeps the association?  calling old_hx_gift_card.reload effectively re-searches for study_subject's hx_gift_card, NOT reloading the gift card by id!, which seems very, very wrong to me.
			old_hx_gift_card = GiftCard.find(@study_subject.hx_gift_card.id)
#			old_hx_gift_card.update_attribute(:study_subject, nil)
#			old_hx_gift_card.update_attributes!(:study_subject => nil)
			old_hx_gift_card.update_attributes!(:study_subject_id => nil)
#			@study_subject.hx_gift_card.update_attributes!(:study_subject => nil)
		end
#	This will auto save and don't want that
#		@gift_card.study_subject = @study_subject
		@gift_card.study_subject_id = @study_subject.id
#	Not currently necessary as the gift cards' fixtures already has a project_id
#		@gift_card.project = Project['HomeExposures']
		@gift_card.issued_on = params[:gift_card][:issued_on]
		@gift_card.save!
		flash[:notice] = 'Success!'
		redirect_to followup_study_subject_path(@study_subject)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the gift card"
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
			access_denied("Valid gift_card id required!", followup_study_subjects_path)
		end
	end

end
