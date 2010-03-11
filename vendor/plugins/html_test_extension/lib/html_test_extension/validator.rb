require 'active_support'
module HtmlTestExtension
	module Validator

		def self.included(base)
			base.class_eval do
				# Begin added by Jake
				# verbose = true shows "validating ..."
				# verbose = false shows NOTHING
				@@verbose = true
				cattr_accessor :verbose
				#
				#	revalidate_all = true will validate every call to a url
				#	revalidate_all = false will only validate the first call to a url
				@@revalidate_all = true
				cattr_accessor :revalidate_all
			end
		end

	end
end
