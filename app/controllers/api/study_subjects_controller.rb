class Api::StudySubjectsController < ApplicationController
	skip_before_filter :login_required
	before_filter :authenticate
#	def index
#		@study_subjects = StudySubject.all(:limit => 5 )
#		respond_to do |format|
#			format.xml	{ render :xml => @study_subjects }
#		end
#	end
	def show
		@study_subject = StudySubject.find(params[:id])
		respond_to do |format|
			format.xml	{ render :xml => @study_subject }
		end
	end
protected
	def authenticate
		config = YAML::load(ERB.new(IO.read('config/api.yml')).result)
		authenticate_or_request_with_http_basic do |username, password|
				username == config[:user] && password == config[:password]
		end
	end
end
