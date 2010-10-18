module PermissiveController
	def self.included(base)
		base.extend(ClassMethods)
	end
	module ClassMethods
		def permissive(*args)
			options = args.extract_options!
			resource = options[:resource] || ActiveSupport::ModelName.new(
				self.model_name.gsub(/Controller$/,'').singularize)

			before_filter "may_create_#{resource.plural}_required",
				:only => [:new,:create]
			before_filter "may_read_#{resource.plural}_required",
				:only => [:show,:index]
			before_filter "may_update_#{resource.plural}_required",
				:only => [:edit,:update]
			before_filter "may_destroy_#{resource.plural}_required",
				:only => :destroy

		end
	end
end
ActionController::Base.send(:include,PermissiveController)
