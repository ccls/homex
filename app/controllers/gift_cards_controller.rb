class GiftCardsController < ApplicationController

#	before_filter :may_create_gift_cards_required, 
#		:only => [:new,:create]
#	before_filter :may_read_gift_cards_required, 
#		:only => [:show,:index]
#	before_filter :may_update_gift_cards_required, 
#		:only => [:edit,:update]
#	before_filter :may_destroy_gift_cards_required,
#		:only => :destroy

#	before_filter :valid_id_required, :only => [:show,:edit,:update,:destroy]

	resourceful

#	def index
#		@gift_cards = GiftCard.all
#	end

#	def new
#		@gift_card = GiftCard.new
#	end

#	def create
#		@gift_card = GiftCard.new(params[:gift_card])
#		@gift_card.save!
#		flash[:notice] = 'Success!'
#		redirect_to @gift_card
#	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
#		flash.now[:error] = "There was a problem creating the gift_card"
#		render :action => "new"
#	end
#
#	def update
#		@gift_card.update_attributes!(params[:gift_card])
#		flash[:notice] = 'Success!'
#		redirect_to gift_cards_path
#	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
#		flash.now[:error] = "There was a problem updating the gift_card"
#		render :action => "edit"
#	end

#	def destroy
#		@gift_card.destroy
#		redirect_to gift_cards_path
#	end
#
#protected
#
#	def valid_id_required
#		if !params[:id].blank? and GiftCard.exists?(params[:id])
#			@gift_card = GiftCard.find(params[:id])
#		else
#			access_denied("Valid id required!", gift_cards_path)
#		end
#	end
	
end
