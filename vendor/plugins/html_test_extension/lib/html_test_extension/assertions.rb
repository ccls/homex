module HtmlTestExtension
	module Assertions

		def self.included(base)
			base.module_eval do
				def assert_validates_with_verbosity_control(
					types = nil, body = nil, 
					url = nil, options = {})
					options[:verbose] = Html::Test::Validator.verbose
					assert_validates_without_verbosity_control(
						types, body, url, options )
				end
				alias_method_chain :assert_validates, :verbosity_control
			end
		end

	end
end
