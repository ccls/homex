module AegisExtension
	module Permissions
		def self.included(base)
			base.extend ClassMethods  
		end

		module ClassMethods
			#	See the 'normalized' permissions created
			def permission_names
				@permission_blocks.keys
			end

			def exists?(permission)
				self.permission_names.include?(
					Aegis::Normalization.normalize_permission(permission.to_s).to_sym
				)
			end
		end

	end
end
