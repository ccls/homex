module ResourcefulController
	def self.included(base)
		base.extend(ClassMethods)
	end
	module ClassMethods
		def resourceful(*args)
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

			before_filter :valid_id_required, 
				:only => [:show,:edit,:update,:destroy]

			#	by using before filters, the user
			#	can still add stuff to the action.
			before_filter :get_all, :only => :index
			before_filter :get_new, :only => :new

			define_method :destroy do
				instance_variable_get("@#{resource.singular}").send(:destroy)
				redirect_to send("#{resource.plural}_path")
			end

			define_method :create do
			begin
				instance_variable_set("@#{resource.singular}",
					resource.constantize.send(:new,params[resource.singular]))
				instance_variable_get("@#{resource.singular}").send(:save!)
				flash[:notice] = 'Success!'
				redirect_to instance_variable_get("@#{resource.singular}")
			rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
				flash.now[:error] = "There was a problem creating " <<
					"the #{resource.singular}"
				render :action => "new"
			end
			end 

			define_method :update do
			begin
				instance_variable_get("@#{resource.singular}").send(
					:update_attributes!,params[resource.singular])
				flash[:notice] = 'Success!'
				redirect_to send("#{resource.plural}_path")
			rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
				flash.now[:error] = "There was a problem updating " <<
					"the #{resource.singular}"
				render :action => "edit"
			end
			end

		protected

			define_method :get_all do
				self.instance_variable_set("@#{resource.plural}",
					resource.constantize.send(:all) )
			end

			define_method :get_new do
				self.instance_variable_set("@#{resource.singular}",
					resource.constantize.send(:new) )
			end

			define_method :valid_id_required do
				if( !params[:id].blank? && 
						resource.constantize.send(:exists?,params[:id]) )
					self.instance_variable_set("@#{resource.singular}",
						resource.constantize.send(:find,params[:id]) )
				else
					access_denied("Valid id required!",
						send("#{resource.plural}_path") )
				end
			end
		end
#		alias_method :i_am_resourceful, :resourceful
#		alias_method :i_am_resourceful_too, :resourceful
#		alias_method :i_am_really_resourceful, :resourceful

	end
end
ActionController::Base.send(:include,ResourcefulController)
