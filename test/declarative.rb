module My
	module Declarative

		def test(name, &block)
			test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
			defined = instance_method(test_name) rescue false
			raise "#{test_name} is already defined in #{self}" if defined
			if block_given?
				define_method("_#{test_name}", &block)
#				define_method(test_name) do
#					print "\n#{self.class.name.gsub(/Test$/,'')} #{name}: "
#				doing it this way NEVER seems to fail??
#				tried block.call too
#					block
#				end
			else
				define_method("_#{test_name}") do
#				define_method(test_name) do
					flunk "No implementation provided for #{name}"
				end
			end


			define_method(test_name) do
				print "\n#{self.class.name.gsub(/Test$/,'')} #{name}: "
				send("_#{test_name}")
			end
			#
			#	can't do this.  
			#		alias_method_chain test_name, :verbosity
			#	end up with 2 methods that begin
			#	with 'test_' so they both get run
			#
#			alias_method "do_not_#{test_name}_without_verbosity".to_sym,
#				test_name
#			alias_method test_name,
#				"#{test_name}_with_verbosity".to_sym
		end
	end
end
ActiveSupport::TestCase.send(:extend, My::Declarative)
#
#	I really was hoping to use alias_method_chain on test
#	creating a test_with_verbosity method and a
#	test_without_verbosity alias to test.
#
#	This never seemed to work and at best I would get
#
#		NameError: undefined method `test_with_verbosity' for 
#			class `ActiveSupport::TestCase'
#
#						or
#
#		./test/unit/../declarative.rb:26:in `test_without_verbosity': 
#			wrong number of arguments (1 for 2) (ArgumentError)
#
#	In the end, simply overwriting the existing 'test' 
#	method seemed to be the only way.
#
