class PeopleController < ApplicationController

	before_filter :may_administrate_required

	before_filter :valid_id_required, :only => [:show,:edit,:update,:destroy]

	def index
		@people = Person.all
	end

	def new
		@person = Person.new
	end

	def create
		@person = Person.new(params[:person])
		@person.save!
		flash[:notice] = 'Success!'
		redirect_to @person
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the person"
		render :action => "new"
	end

	def update
		@person.update_attributes!(params[:person])
		redirect_to @person
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the person"
		render :action => "edit"
	end

	def destroy
		@person.destroy
		redirect_to people_path
	end

protected

	def valid_id_required
		if !params[:id].blank? and Person.exists?(params[:id])
			@person = Person.find(params[:id])
		else
			access_denied("Valid id required!", people_path)
		end
	end
	
end
