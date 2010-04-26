class DustKitsController < ApplicationController

	before_filter :may_view_dust_kits_required
	before_filter :valid_subject_id_required

	def show
		@dust_kit = @subject.dust_kit || @subject.build_dust_kit
	end

	def new
		@dust_kit = @subject.build_dust_kit
	end

	def create
		@dust_kit = @subject.build_dust_kit(params[:dust_kit])
		@dust_kit.save!
		flash[:notice] = 'Success!'
		redirect_to subject_path(@subject)
	rescue ActiveRecord::RecordNotSaved
		flash.now[:error] = "There was a problem creating the dust kit"
		render :action => "new"
	end

	def edit
		@dust_kit = @subject.dust_kit || @subject.build_dust_kit
	end

	def update
		@dust_kit = @subject.dust_kit
		@dust_kit.update_attributes!(params[:dust_kit])
		redirect_to subject_path(@subject)
	rescue ActiveRecord::RecordNotSaved
		flash.now[:error] = "There was a problem updating the dust kit"
		render :action => "edit"
	end

	def destroy
		if @subject.dust_kit.destroy
			flash[:error] = "Dust Kit destruction failed."
		end
		redirect_to subject_path(@subject)
	end

protected

	def valid_subject_id_required
		if !params[:subject_id].blank? and Subject.exists?(params[:subject_id])
			@subject = Subject.find(params[:subject_id])
		else
			access_denied("Valid subject id required!", subjects_path)
		end
	end

end
