module HtmlTestExtension
	module ValidateFilter

		def self.included(base)
			base.extend ClassMethods
		end

		module ClassMethods
			def already_validated?(url)
				#	always return false so it is always validated
				false	
			end
		end

	end
end
