module NoAccessWithLogin

	def self.included(base)
		base.extend ClassMethods
		base.send(:include, InstanceMethods)
	end

	module ClassMethods

		def nawil_title(options={})
			"with #{options[:login]} login#{options[:suffix]}"
		end

		def assert_no_access_with_login(*actions)
			user_options = actions.extract_options!

			options = {}
			if ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)

			m_key = options[:model].try(:underscore).try(:to_sym)

			test "NAWiL should NOT get new #{nawil_title(options)}" do
				login_as send(options[:login])
				args = options[:new]||{}
				send(:get,:new,args)
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:new) || options.keys.include?(:new)

			test "NAWiL should NOT post create #{nawil_title(options)}" do
				login_as send(options[:login])
				args = if options[:create]
					options[:create]
				elsif options[:attributes_for_create]
					{m_key => send(options[:attributes_for_create])}
				else
#					{m_key => Factory.attributes_for(options[:factory])}
					{}
				end
				assert_no_difference("#{options[:model]}.count") do
					send(:post,:create,args)
				end
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:create) || options.keys.include?(:create)

			test "NAWiL should NOT get edit #{nawil_title(options)}" do
				login_as send(options[:login])
				args=options[:edit]||{}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
#				elsif options[:factory]
#					obj = Factory(options[:factory])
#					args[:id] = obj.id
				end
				send(:get,:edit, args)
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "NAWiL should NOT put update #{nawil_title(options)}" do
				login_as send(options[:login])
				args={}
				if options[:method_for_create] && options[:attributes_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
					args[m_key] = send(options[:attributes_for_create])
#				elsif options[:factory]
#					obj = Factory(options[:factory])
#					args[:id] = obj.id
#					args[m_key] = Factory.attributes_for(options[:factory])
				end
				send(:put,:update, args)
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:update) || options.keys.include?(:update)

			test "NAWiL should NOT get show #{nawil_title(options)}" do
				login_as send(options[:login])
				args=options[:show]||{}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
#				elsif options[:factory]
#					obj = Factory(options[:factory])
#					args[:id] = obj.id
				end
				send(:get,:show, args)
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:show) || options.keys.include?(:show)

			test "NAWiL should NOT delete destroy #{nawil_title(options)}" do
				login_as send(options[:login])
				args=options[:destroy]||{}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
#				elsif options[:factory]
#					obj = Factory(options[:factory])
#					args[:id] = obj.id
				end
				assert_no_difference("#{options[:model]}.count") do
					send(:delete,:destroy,args)
				end
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "NAWiL should NOT get index #{nawil_title(options)}" do
				login_as send(options[:login])
				get :index
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:index) || options.keys.include?(:index)

		end

	end

	module InstanceMethods

		#	This needs to be static and not dynamic or the multiple
		#	calls that would create it would overwrite each other.
		def nawil_redirection(options={})
			if options[:redirect]
				send(options[:redirect])
			else
				root_path
			end
		end

	end
end
ActionController::TestCase.send(:include, NoAccessWithLogin)
