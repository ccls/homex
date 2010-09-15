class GuidesController < ApplicationController

	before_filter :may_create_guides_required, 
		:only => [:new,:create]
	before_filter :may_read_guides_required, 
		:only => [:show,:index]
	before_filter :may_update_guides_required, 
		:only => [:edit,:update]
	before_filter :may_destroy_guides_required,
		:only => :destroy

	before_filter :valid_id_required,
		:only => [:show,:edit,:update,:destroy]

	def index
		@guides = Guide.all
	end

	def new
		@guide = Guide.new
	end

	def create
		@guide = Guide.new(params[:guide])
		@guide.save!
		redirect_to(@guide, :notice => 'Guide was successfully created.')
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Guide creation failed"
		render :action => "new"
	end

	def update
		@guide.update_attributes!(params[:guide])
		redirect_to(@guide, :notice => 'Guide was successfully updated.')
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Guide update failed"
		render :action => 'edit'
	end

	def destroy
		@guide.destroy
		redirect_to(guides_url)
	end

protected

	def valid_id_required
		if !params[:id].blank? and Guide.exists?(params[:id])
			@guide = Guide.find(params[:id])
		else
			access_denied("Valid guide id required!", 
				guides_path)
		end
	end

end
