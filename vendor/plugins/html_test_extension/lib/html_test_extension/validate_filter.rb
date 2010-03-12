module HtmlTestExtension
	module ValidateFilter

		def self.included(base)
			base.extend ClassMethods
			#	Because I'm overwriting an existing method
			#	I need to class_eval and not extend?
			base.class_eval do
				def self.already_validated?(url)
					if Html::Test::Validator.revalidate_all
						false
					else
						validated_urls[url]
					end
				end
			end
		end

		module ClassMethods
			#	Used in testing (of this plugin)
			#	to remove the validated_urls hash
			#	so can test with the same url.
			def clear_validated_urls
				@validated_urls = {}
			end
		end

	end
end
