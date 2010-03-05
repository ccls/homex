module AegisExtension
	module Role

		def self.included(base)
			attr_reader :options
			base.extend ClassMethods  
			base.send(:include, InstanceMethods)
			#	initialize is special and I could't seem
			#	to override as a class or instance method
#	Thanks to ...
#	http://pivotallabs.com/users/rolson/blog/articles/1162-redefine-a-method-from-a-module-like-a-gentleman
			base.class_eval do
				alias_method :original_initialize, :initialize
				def initialize(name, permissions, options)
					@options = options
					original_initialize(name, permissions, options)
				end
			end

		end

		module InstanceMethods
		end

		module ClassMethods
		end

	end
end
