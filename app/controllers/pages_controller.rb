class PagesController < ApplicationController	#:nodoc:

	skip_before_filter :cas_filter, :only => :show
	before_filter :cas_gateway_filter, :only => :show
	before_filter :may_maintain_pages_required, :except => :show
	before_filter :id_required, :only => [ :edit, :update, :destroy ]

#	caches partials from layout as well, which is too much
#	caches_action :show, :layout => false
#	cache_sweeper :page_sweeper, :only => [:create, :update, :order, :destroy]

	def order
		params[:pages].reverse.each { |id| Page.find(id).move_to_top }
		redirect_to pages_path
	end

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
		@page_title = "CCLS Pages"
		@pages = Page.all(:conditions => { :parent_id => params[:parent_id] })
	end

	def new
		@page_title = "Create New CCLS Page"
		@page = Page.new(:parent_id => params[:parent_id])
	end

	def edit
		@page_title = "Edit CCLS Page #{@page.title}"
	end

	def create
#		# match the value of the submit button clicked
#		if params[:commit] !~ /cancel/i
			@page = Page.new(params[:page])
			@page.save!
			flash[:notice] = 'Page was successfully created.'
			redirect_to(@page)
#		else
#			flash[:notice] = 'Page creation canceled.'
#			redirect_to pages_path
#		end
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the page"
		render :action => "new"
	end

	def update
#		# match the value of the submit button clicked
#		if params[:commit] !~ /cancel/i
			@page.update_attributes!(params[:page])
			flash[:notice] = 'Page was successfully updated.'
#		else
#			flash[:notice] = 'Page update canceled.'
#		end
		redirect_to(@page)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the page."
		render :action => "edit"
	end

	def destroy
		@page.destroy
		redirect_to(pages_path)
	end

protected

	def id_required
		if !params[:id].blank? and Page.exists?(params[:id])
			@page = Page.find(params[:id])
		else
			access_denied("Valid page id required!", pages_path)
		end
	end

end
