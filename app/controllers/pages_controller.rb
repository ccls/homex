class PagesController < ApplicationController

	skip_before_filter :cas_filter	#	user does not need to be logged in to view pages
#	skip_before_filter CASClient::Frameworks::Rails::Filter
	before_filter :cas_gateway_filter
 
end
