module AegisExtension
	module ActionController

		def self.included(base)
			base.send(:include, InstanceMethods)
		end

		module InstanceMethods

			def aegis_current_user
				current_user
			end

			def aegis_access_denied(message="Access Denied.")
				flash[:error] = message
				redirect_to( session[:refer_to] || request.env["HTTP_REFERER"] || "/" )
				session[:refer_to] = nil
			end


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
#	Aegis::Permissions.subclasses.collect{|p| "::#{p}".constantize.exists?($1)}.any?
		
				if method_name =~ /^may_(not_)?(.+)_required$/ && ::Permissions.exists?($2)
					negate = !!$1		#	double bang converts to boolean
					permission_name = $2
					verb,target = permission_name.split(/_/,2)
		
					#	using target words where singular == plural won't work here
					if !target.blank? && target == target.singularize
						unless permission = aegis_current_user.try(
								"may_#{permission_name}?", 
								instance_variable_get("@#{target}") 
							)
							message = "You don't have permission to #{verb} this #{target}."
						end
					else
						#	current_user may be nil so must use try and NOT send
						unless permission = aegis_current_user.try("may_#{permission_name}?")
							message = "You don't have permission to #{permission_name.gsub(/_/,' ')}."
						end
					end

					#	exclusive or
					unless negate ^ permission
						#	if message is nil, negate will be true
						message ||= "Access denied.  May #{(negate)?'not ':''}#{permission_name.gsub(/_/,' ')}."
						aegis_access_denied message||"Access denied."
					end

				else
					method_missing_without_aegis_permissions(symb, *args)
				end
			end
			alias_method_chain :method_missing, :aegis_permissions

		end
	end
end
