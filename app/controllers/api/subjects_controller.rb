class Api::SubjectsController < ApplicationController
	skip_before_filter :login_required
	before_filter :authenticate
	def index
		@subjects = Subject.all(:limit => 5 )
		respond_to do |format|
			format.xml	{ render :xml => @subjects }
		end
	end
	def show
		@subject = Subject.find(params[:id])
		respond_to do |format|
			format.xml	{ render :xml => @subject }
		end
	end
protected
	def authenticate
		authenticate_or_request_with_http_basic do |username, password|
				username == "admin" && password == "secret"
		end
	end
end
