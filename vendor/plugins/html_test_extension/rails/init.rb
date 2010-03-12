#if Rails.env == 'test'
#if RAILS_ENV == 'test'
if !defined?(RAILS_ENV) || RAILS_ENV == 'test'
	require 'html_test'
	require 'html_test_extension'

	#	Assertions is a Module not a class, so I'm not sure how this'll go
#	Html::Test::Assertions.send(:include, 
#		HtmlTestExtension::Assertions)
#
#	Defining the above will cause the following to appear 
#	after any rake call which I find really annoying.  I 
#	also find it odd that rails skips the plugin's conditional 
#	load of this very file.  Adding the 'if' wrapper stops
#	this behavior.
#
#	Loaded suite /usr/bin/rake
#Started
#
#Finished in 0.000139 seconds.
#
#0 tests, 0 assertions, 0 failures, 0 errors
#
#	Html::Test::Validator.send(:include, 
#		HtmlTestExtension::Validator)
#	Html::Test::ValidateFilter.send(:include, 
#		HtmlTestExtension::ValidateFilter)
end
