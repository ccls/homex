class HomePagePicsController < ApplicationController

	before_filter :may_view_home_page_pics_required
	before_filter :valid_id_required, 
		:except => [:index,:activate,:new,:create]

	def activate
		#["1", {"active"=>"true"}]
		#["2", {"active"=>"false"}]
		params[:home_page_pics].each do |hpp|
			HomePagePic.find(hpp[0]).update_attributes!(
				:active => hpp[1]['active'])
		end
		flash[:notice] = "Active statuses updated."
		redirect_to home_page_pics_path
	rescue
		flash[:error] = "Something bad happened?"
		redirect_to home_page_pics_path
	end

	def index
		@home_page_pics = HomePagePic.all
	end

	def show
		@home_page_pic = HomePagePic.find(params[:id])
	end

	def new
		@home_page_pic = HomePagePic.new
	end

	def edit
		@home_page_pic = HomePagePic.find(params[:id])
	end

	def create
		@home_page_pic = HomePagePic.new(params[:home_page_pic])

		if @home_page_pic.save
			flash[:notice] = 'HomePagePic was successfully created.'
			redirect_to(@home_page_pic)
		else
			flash[:error] = 'HomePagePic creation failed.'
			render :action => "new"
		end
	end

	def update
		@home_page_pic = HomePagePic.find(params[:id])

		if @home_page_pic.update_attributes(params[:home_page_pic])
			flash[:notice] = 'HomePagePic was successfully updated.'
			redirect_to(@home_page_pic)
		else
			flash[:error] = 'HomePagePic update failed.'
			render :action => "edit"
		end
	end

	def destroy
		@home_page_pic = HomePagePic.find(params[:id])
		@home_page_pic.destroy

		redirect_to(home_page_pics_url)
	end

protected

	def valid_id_required
		if !params[:id].blank? and HomePagePic.exists?(params[:id])
			@home_page_pic = HomePagePic.find(params[:id])
		else
			access_denied("HomePagePic id required!", home_page_pics_path)
		end
	end

end
