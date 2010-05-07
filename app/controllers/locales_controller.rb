class LocalesController < ApplicationController
	skip_before_filter :cas_filter
	def update
		session[:locale] = params[:locale]
		respond_to do |format|
			format.html { redirect_to_referer_or_default(root_path) }
			format.js { render :text => '' }
		end
	end
end
