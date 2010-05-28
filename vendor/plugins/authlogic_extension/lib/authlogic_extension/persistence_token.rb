module AuthlogicExtension  #:nodoc:
module ActsAsAuthentic     #:nodoc:
module PersistenceToken

	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
			alias_method_chain :reset_persistence_token, :uniqueness
		end
	end

	module InstanceMethods

	protected

		#	Yes, this is ridiculously unlikely, but this attribute
		#	is validated as unique, but no effort is made to ensure
		#	that it actually is unique.  This number is HUGE,
		#	but if a random number was chosen and was the same
		#	as another, the error would not be the user's fault.
		def reset_persistence_token_with_uniqueness
			begin
				reset_persistence_token_without_uniqueness
			end while ( 
				self.class.find_by_persistence_token(self.persistence_token) )
		end

	end

end
end
end
