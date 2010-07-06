class Hx::DustKitsController < HxApplicationController

	before_filter :may_view_dust_kits_required
	before_filter :valid_hx_subject_id_required

	def show
		@last_shipping_update = Package.last_updated
		@dust_kit = @subject.dust_kit || @subject.build_dust_kit
	end

	def new
		@dust_kit = @subject.build_dust_kit
	end

	def create
		@dust_kit = @subject.build_dust_kit(params[:dust_kit])
		@dust_kit.save!
		flash[:notice] = 'Success!'
		redirect_to hx_subject_path(@subject)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the dust kit"
		render :action => "new"
	end

	def edit
		@dust_kit = @subject.dust_kit || @subject.build_dust_kit
	end

	def update
		@dust_kit = @subject.dust_kit
		@dust_kit.update_attributes!(params[:dust_kit])
		redirect_to hx_subject_path(@subject)
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the dust kit"
		render :action => "edit"
	end

	def destroy
		@subject.dust_kit.destroy
		redirect_to hx_subject_path(@subject)
	end

end
