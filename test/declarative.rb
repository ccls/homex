module My
	module Declarative

		def self.included(base)
			base.extend ClassMethods
			base.class_eval do
				class << self
					alias_method_chain :test, :verbosity
				end
			end
		end

		module ClassMethods

			def test_with_verbosity(name,&block)
				test_without_verbosity(name,&block)

				test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
				define_method("_#{test_name}_with_verbosity") do
					print "\n#{self.class.name.gsub(/Test$/,'')} #{name}: "
					send("_#{test_name}_without_verbosity")
				end
				#
				#	can't do this.  
				#		alias_method_chain test_name, :verbosity
				#	end up with 2 methods that begin
				#	with 'test_' so they both get run
				#
				alias_method "_#{test_name}_without_verbosity".to_sym,
					test_name
				alias_method test_name,
					"_#{test_name}_with_verbosity".to_sym
			end

		end	#	ClassMethods

	end
end
ActiveSupport::TestCase.send(:include,My::Declarative)

Rails.backtrace_cleaner.add_silencer {|line|
	line =~ /\/test\/.*\.\.\/declarative\.rb:/
#	Due to my modification, every error is accompanied by 
#		3 additional and unnecessary lines like ...
#	/test/functional/../declarative.rb:21:in `_test_should_change_locale_to_es_without_verbosity'
#/test/functional/../declarative.rb:21:in `send'
#/test/functional/../declarative.rb:21:in `_test_should_change_locale_to_es_with_verbosity']:

} 
