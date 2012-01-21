class Followup::StudySubjectsController < ApplicationController

#	permissive

	before_filter :may_create_study_subjects_required,
		:only => [:new,:create]
	before_filter :may_read_study_subjects_required,
		:only => [:show,:index]
	before_filter :may_update_study_subjects_required,
		:only => [:edit,:update]
	before_filter :may_destroy_study_subjects_required,
		:only => :destroy

	before_filter :valid_id_for_hx_study_subject_required,
		:only => [:show,:edit,:update]
	before_filter :valid_gift_card_required, :only => :update

	def index
		record_or_recall_sort_order
		if params[:commit] && params[:commit] == 'download'
			params[:paginate] = false
		end
		@study_subjects = StudySubject.search( params.dup.deep_merge(
			:projects=>{ Project['HomeExposures'].id =>{}},
			:search_gift_cards => true,
			:sample_outcome => 'complete',
			:interview_outcome => 'complete'
		))
		if params[:commit] && params[:commit] == 'download'
			params[:format] = 'csv'
			headers["Content-disposition"] = "attachment; " <<
				"filename=study_subjects_#{Time.now.to_s(:filename)}.csv" 
			render :template => "study_subjects/index"
		end
	end

	def show
		@gift_card = @study_subject.gift_cards.find_by_project_id(Project['HomeExposures'].id)
	end

	def edit
		@hx_gift_card = @study_subject.gift_cards.find_by_project_id(Project['HomeExposures'].id)

		#	NOTE I don't think that there is currently anything restrict a 
		#	subject from having more than one gift card for a project
		@gift_cards  = [@hx_gift_card].compact
		@gift_cards += GiftCard.find(:all,
			:conditions => {:study_subject_id => nil })
	end

#
#	Basically unassign old gift_card and reassign new one.
#
	def update
		hx_gift_card = @study_subject.gift_cards.find_by_project_id(Project['HomeExposures'].id)
		if !hx_gift_card.nil? && hx_gift_card != @gift_card
			hx_gift_card.update_attributes!(:study_subject_id => nil)
		end
		@gift_card.study_subject_id = @study_subject.id
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
