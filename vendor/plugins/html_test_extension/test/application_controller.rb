class ApplicationController < ActionController::Base
#
#	The default settings, called from lib/html_test_extension.rb,
#	expect to have an ApplicationController.  Outside of a rails app,
#	, like in plugin testing, this needs defined.  I tried defining
#	it in the test_helper, but it did not work.  Defining this
#	empty file does the trick though.
#
end
