class PagesController < ApplicationController

	skip_before_filter :cas_filter, :only => :show
	before_filter :cas_gateway_filter, :only => :show
	before_filter :admin_required, :except => :show


	def show
		if params[:path]
 			@page = Page.by_path("/#{params[:path].join('/')}")
			raise ActiveRecord::RecordNotFound if @page.nil?
		else
			@page = Page.find(params[:id])
		end
		@page_title = @page.title
	rescue ActiveRecord::RecordNotFound
		flash_message = "Page not found with "
		flash_message << (( params[:id].blank? ) ? "path '/#{params[:path].join('/')}'" : "ID #{params[:id]}")
		flash[:error] = flash_message
	end

	def index
		@pages = Page.all
	end

	def new
		@page_title = "Create New Page"
		@page = Page.new
	end

	def edit
		@page_title = "Edit Page"
		@page = Page.find(params[:id])
	end

	def create
		@page = Page.new(params[:page])
		@page.save!
		flash[:notice] = 'Page was successfully created.'
		redirect_to(@page)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the page"
		render :action => "new"
	end

	def update
		@page = Page.find(params[:id])
		@page.update_attributes!(params[:page])
		flash[:notice] = 'Page was successfully updated.'
		redirect_to(@page)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the page."
		render :action => "edit"
	end

	def destroy
		@page = Page.find(params[:id])
		@page.destroy
		redirect_to(pages_path)
	end
 
end
