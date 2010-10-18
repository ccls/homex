class HomePagePicsController < ApplicationController

	resourceful

	before_filter :may_update_home_page_pics_required, 
		:only => [:edit,:update,:activate]

	def activate
		#["1", {"active"=>"true"}]
		#["2", {"active"=>"false"}]
		params[:home_page_pics].each do |hpp|
			HomePagePic.find(hpp[0]).update_attributes!(
				:active => hpp[1]['active'])
		end
		flash[:notice] = "Active statuses updated."
	rescue
		flash[:error] = "Something bad happened?"
	ensure
		redirect_to home_page_pics_path
	end

end
