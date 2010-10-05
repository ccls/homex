ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage
require 'factory_test_helper'
require 'package_test_helper'

#	Using default validation settings from within the 
#	html_test and html_test_extension plugins

class ActiveSupport::TestCase

	self.use_transactional_fixtures = true
	self.use_instantiated_fixtures  = false
	fixtures :all

	def model_name
		self.class.name.sub(/Test$/,'')
	end

	def method_missing(symb,*args, &block)
		method = symb.to_s
#		if method =~ /^create_(.+)(\!?)$/
		if method =~ /^create_([^!]+)(!?)$/
			factory = if( $1 == 'object' )
#	doesn't work for controllers yet.  Need to consider
#	singular and plural as well as "tests" method.
#	Probably should just use the explicit factory
#	name in the controller tests.
#				self.class.name.sub(/Test$/,'').underscore
				model_name.underscore
			else
				$1
			end
			bang = $2
			options = args.extract_options!
			if bang.blank?
				record = Factory.build(factory,options)
				record.save
				record
			else
				Factory(factory,options)
			end
		else
			super(symb,*args, &block)
		end
	end

	include FactoryTestHelper

	def assert_subject_is_eligible(subject)
		assert_nil   subject.hx_enrollment.ineligible_reason_id
		assert_equal subject.hx_enrollment.is_eligible, YNDK[:yes]
	end

	def assert_subject_is_not_eligible(subject)
		assert_not_nil subject.hx_enrollment.ineligible_reason_id
		assert_equal   subject.hx_enrollment.is_eligible, YNDK[:no]
	end

	def self.assert_should_create_default_object
		test "should create default #{model_name.underscore}" do
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_object
				assert !object.new_record?, 
					"#{object.errors.full_messages.to_sentence}"
			end
		end
	end

	def self.assert_requires_complete_date(*attr_names)
		attr_names.each do |attr_name|
			test "should require a complete date for #{attr_name}" do
				assert_difference( "#{model_name}.count", 0 ) do
					object = create_object( attr_name => "Sept 2010")
					assert object.errors.on(attr_name)
				end
			end
		end
	end

end

class ActionController::TestCase

	setup :turn_https_on

end
