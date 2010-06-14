module NoAccessWithLogin

	def self.included(base)
		base.extend ClassMethods
		base.send(:include, InstanceMethods)
	end

	module ClassMethods

		def nawil_title
			"with #{@options[:login]} login#{@options[:suffix]}"
		end

		def assert_no_access_with_login(actions=[],options={})

			@options = options

			test "NAWiL should NOT get new #{nawil_title}" do
				login_as send(options[:login])
				args = options[:new]||{}
				send(:get,:new,args)
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:new) || options.keys.include?(:new)

			test "NAWiL should NOT post create #{nawil_title}" do
				login_as send(options[:login])
				model = options[:factory].to_s.camelize
				args = if options[:create]
					options[:create]
				else
					{options[:factory] => Factory.attributes_for(options[:factory])}
				end
				assert_no_difference("#{model}.count") do
					send(:post,:create,args)
				end
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:create) || options.keys.include?(:create)

			test "NAWiL should NOT get edit #{nawil_title}" do
				login_as send(options[:login])
				args=options[:edit]||{}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
				end
				send(:get,:edit, args)
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "NAWiL should NOT put update #{nawil_title}" do
				login_as send(options[:login])
				args={}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
					args[options[:factory]] = Factory.attributes_for(options[:factory])
				end
				send(:put,:update, args)
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:update) || options.keys.include?(:update)

			test "NAWiL should NOT get show #{nawil_title}" do
				login_as send(options[:login])
				args=options[:show]||{}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
				end
				send(:get,:show, args)
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:show) || options.keys.include?(:show)

			test "NAWiL should NOT delete destroy #{nawil_title}" do
				login_as send(options[:login])
				model = options[:model]||options[:factory].to_s.camelize
				args=options[:destroy]||{}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
				end
				assert_no_difference("#{model}.count") do
					send(:delete,:destroy,args)
				end
				assert_not_nil flash[:error]
				assert_redirected_to nawil_redirection(options)
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "NAWiL should NOT get index #{nawil_title}" do
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
