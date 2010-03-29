class SubjectsController < ApplicationController
	before_filter :may_view_subjects_required

	def index
		@subjects = Subject.all
	end

	def show
		@subject = Subject.find(params[:id])
	end

end
