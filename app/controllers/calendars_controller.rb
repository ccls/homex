class CalendarsController < ApplicationController

	before_filter :may_view_calendar_required

	def show

	end

end
