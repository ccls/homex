class RacesController < ApplicationController

	before_filter :may_maintain_races_required
	before_filter :valid_id_required, :only => [:show,:edit,:update,:destroy]

	def index
		@races = Race.all
	end

	def new
		@race = Race.new
	end

	def create
		@race = Race.new(params[:race])
		@race.save!
		flash[:notice] = 'Success!'
		redirect_to @race
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the race"
		render :action => "new"
	end

	def update
		@race.update_attributes!(params[:race])
		redirect_to @race
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the race"
		render :action => "edit"
	end

	def destroy
		@race.destroy
		redirect_to races_path
	end

protected

	def valid_id_required
		if !params[:id].blank? and Race.exists?(params[:id])
			@race = Race.find(params[:id])
		else
			access_denied("Valid id required!", races_path)
		end
	end
	
end
