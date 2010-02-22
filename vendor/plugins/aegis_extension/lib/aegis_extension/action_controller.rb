module AegisExtension
	module ActionController

		def self.included(base)
#			base.extend  ClassMethods  
			base.send(:include, InstanceMethods)
		end

#		module ClassMethods
#		end

		module InstanceMethods

			#	This works when the permission does not take an argument.
			#		may_deputize_required
			#		may_maintain_pages_required
			#		may_view_users_required
			#	And as long as naming conventions are followed.
			#	Also works for those that follow conventions
			#		may_view_user_required
			#	In the above case, @user must be defined first.
			#	Also, targets must be distinctly singular. (or NOT plural)
			def method_missing_with_aegis_permissions(symb,*args)
				method_name = symb.to_s
		
		
		#		using ::Permissions is app specific
		
		#puts Aegis::Permissions.subclasses
		
		
				if method_name =~ /^may_(.+)_required$/ && ::Permissions.exists?($1)
					permission = $1
					verb,target = permission.split(/_/,2)
		
					#	using target words where singular == plural won't work here
					if !target.blank? && target == target.singularize
						unless current_user.try("may_#{permission}?", instance_variable_get("@#{target}") )
							flash[:error] = "You don't have permission to #{verb} this #{target}."
							redirect_to( session[:refer_to] || request.env["HTTP_REFERER"] || "/" )
							session[:refer_to] = nil
						end
					else
						#	current_user may be nil so must use try and NOT send
						unless current_user.try("may_#{permission}?")
							flash[:error] = "You don't have permission to #{permission.gsub(/_/,' ')}."
							redirect_to( session[:refer_to] || request.env["HTTP_REFERER"] || "/" )
							session[:refer_to] = nil
						end
					end
				else
					method_missing_without_aegis_permissions(symb, *args)
				end
			end
			alias_method_chain :method_missing, :aegis_permissions

		end
	end
end
