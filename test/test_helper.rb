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

	#	basically a copy of assert_difference, but
	#	without any explicit comparison as it is 
	#	simply stating that something will change
	#	(designed for updated_at)
	def assert_changes(expression, message = nil, &block)
		b = block.send(:binding)
		exps = Array.wrap(expression)
		before = exps.map { |e| eval(e, b) }
		yield
		exps.each_with_index do |e, i|
			error = "#{e.inspect} didn't change"
			error = "#{message}.\n#{error}" if message
			assert_not_equal(before[i], eval(e, b), error)
		end
	end

	#	Just a negation of assert_changes
	def deny_changes(expression, message = nil, &block)
		b = block.send(:binding)
		exps = Array.wrap(expression)
		before = exps.map { |e| eval(e, b) }
		yield
		exps.each_with_index do |e, i|
			error = "#{e.inspect} changed"
			error = "#{message}.\n#{error}" if message
			assert_equal(before[i], eval(e, b), error)
		end
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

end

class ActionController::TestCase

	setup :turn_https_on

	def assert_layout(layout)
		layout = "layouts/#{layout}" unless layout.match(/^layouts/)
		assert_equal layout, @response.layout
	end

end
