class RefusalReasonsController < ApplicationController

	resourceful

#	before_filter :may_create_refusal_reasons_required, 
#		:only => [:new,:create]
#	before_filter :may_read_refusal_reasons_required, 
#		:only => [:show,:index]
#	before_filter :may_update_refusal_reasons_required, 
#		:only => [:edit,:update]
#	before_filter :may_destroy_refusal_reasons_required,
#		:only => :destroy
#
#	before_filter :valid_id_required, :only => [:show,:edit,:update,:destroy]
#
#	def index
#		@refusal_reasons = RefusalReason.all
#	end
#
#	def new
#		@refusal_reason = RefusalReason.new
#	end
#
#	def create
#		@refusal_reason = RefusalReason.new(params[:refusal_reason])
#		@refusal_reason.save!
#		flash[:notice] = 'Success!'
#		redirect_to @refusal_reason
#	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
#		flash.now[:error] = "There was a problem creating the refusal_reason"
#		render :action => "new"
#	end
#
#	def update
#		@refusal_reason.update_attributes!(params[:refusal_reason])
#		flash[:notice] = 'Success!'
#		redirect_to refusal_reasons_path
#	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
#		flash.now[:error] = "There was a problem updating the refusal_reason"
#		render :action => "edit"
#	end
#
#	def destroy
#		@refusal_reason.destroy
#		redirect_to refusal_reasons_path
#	end
#
#protected
#
#	def valid_id_required
#		if !params[:id].blank? and RefusalReason.exists?(params[:id])
#			@refusal_reason = RefusalReason.find(params[:id])
#		else
#			access_denied("Valid id required!", refusal_reasons_path)
#		end
#	end
	
end
