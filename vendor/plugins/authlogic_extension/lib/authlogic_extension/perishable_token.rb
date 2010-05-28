module AuthlogicExtension  #:nodoc:
module ActsAsAuthentic     #:nodoc:
module PerishableToken

	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
			alias_method_chain :reset_perishable_token, :uniqueness
		end
	end

	module InstanceMethods

	protected

		#	same as the persistence token, however ....
		#	The perishable_token is created AFTER validation and 
		#	before save, which mean its uniqueness is never 
		#	validated which is really stupid.  This method
		#	will ensure it is unique but won't raise errors.
		def reset_perishable_token_with_uniqueness
			begin
				reset_perishable_token_without_uniqueness
			end while ( 
				self.class.find_by_perishable_token(self.perishable_token) )
		end

	end

end
end
end
