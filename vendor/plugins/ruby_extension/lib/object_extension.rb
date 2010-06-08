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

		#	looking for an explicit true
		def true?
			return [true, 'true', 1, '1', 't'].include?(
				( self.class == String ) ? self.downcase : self )
		end

		#	looking for an explicit false (not nil)
		def false?
			return [false, 'false', 0, '0', 'f'].include?(
				( self.class == String ) ? self.downcase : self )
		end

	end

end
end
Object.send(:include, RubyExtension::ObjectExtension)
