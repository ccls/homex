require 'html_test_extension/assertions'
require 'html_test_extension/validate_filter'
require 'html_test_extension/validator'

#	Assertions is a Module not a class, so I'm not sure how this'll go
Html::Test::Assertions.send(:include, 
		HtmlTestExtension::Assertions)
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
Html::Test::Validator.send(:include, 
		HtmlTestExtension::Validator)
Html::Test::ValidateFilter.send(:include, 
		HtmlTestExtension::ValidateFilter)

##################################################
#	begin my default html_test plugin settings
validate = false
validators = ["http://localhost/w3c-validator/check", 
							Html::Test::Validator.w3c_url]

validators.each do |validator|
	vhost = validator.split('/')[2]
	vpath = "/"<< validator.split('/')[3..-1].join('/')
	begin
		response = Net::HTTP.get_response(vhost, vpath)
		if response.code == '200'
			Html::Test::Validator.w3c_url = validator
			validate = true
			break
		end
	rescue
	end
end

if validate
	ApplicationController.validate_all = true
	#       default is :tidy, but it doesn't really validate.       
	#       I've purposely not closed tags and it doesn't complain.
	#       :w3c is ridiculously slow! even when used locally
	ApplicationController.validators = [:w3c]
	#ApplicationController.validators = [:tidy, :w3c]
	Html::Test::Validator.verbose = false
	Html::Test::Validator.revalidate_all = true
	Html::Test::Validator.tidy_ignore_list = 
		[/<table> lacks "summary" attribute/]
	puts "Validating all html with " <<
		Html::Test::Validator.w3c_url
else
	puts "NOT validating html at all"
end
#	end html_test plugin settings
##################################################
