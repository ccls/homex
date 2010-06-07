module RubyExtension	#	:nodoc:
module ObjectExtension
	def self.included(base)
#		base.extend(ClassMethods)
		base.instance_eval do
			include InstanceMethods
		end
	end

#	module ClassMethods	#	:nodoc:
#	end

	module InstanceMethods

		def to_boolean
#			return [true, 'true', 1, '1', 't'].include?(
			return ![nil, false, 'false', 0, '0', 'f'].include?(
				( self.class == String ) ? self.downcase : self )
		end
		alias_method :true?, :to_boolean

		def false?
			!self.true?
		end

	end

end
end
Object.send(:include, RubyExtension::ObjectExtension)
