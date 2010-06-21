class CalendarsController < ApplicationController

	before_filter :may_view_calendar_required

end
