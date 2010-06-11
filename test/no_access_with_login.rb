module NoAccessWithLogin

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def assert_no_access_with_login(actions=[],options={})

			test "NAWiL should NOT get new with #{options[:login]} login" do
				login_as send(options[:login])
				get :new
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end if actions.include?(:new) || options.keys.include?(:new)

			test "NAWiL should NOT post create with #{options[:login]} login" do
				login_as send(options[:login])
#				args = {}
				model = options[:factory].to_s.camelize
#				args[model] = if options[:create]
				args = if options[:create]
					options[:create]
				else
					{options[:factory] => Factory.attributes_for(options[:factory])}
				end
				assert_no_difference("#{model}.count") do
					send(:post,:create,args)
				end
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end if actions.include?(:create) || options.keys.include?(:create)

			test "NAWiL should NOT get edit with #{options[:login]} login" do
				login_as send(options[:login])
				args=[]
				if options[:factory]
					obj = Factory(options[:factory])
					args.push(:id => obj.id)
				end
				send(:get,:edit, *args)
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "NAWiL should NOT put update with #{options[:login]} login" do
				login_as send(options[:login])
				args={}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
					args[options[:factory]] = Factory.attributes_for(options[:factory])
				end
				send(:put,:update, args)
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end if actions.include?(:update) || options.keys.include?(:update)

			test "NAWiL should NOT get show with #{options[:login]} login" do
				login_as send(options[:login])
				args=[]
				if options[:factory]
					obj = Factory(options[:factory])
					args.push(:id => obj.id)
				end
				send(:get,:show, *args)
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end if actions.include?(:show) || options.keys.include?(:show)

			test "NAWiL should NOT delete destroy with #{options[:login]} login" do
				login_as send(options[:login])
				model = options[:factory].to_s.camelize
				args=[]
				if options[:factory]
					obj = Factory(options[:factory])
					args.push(:id => obj.id)
				end
				assert_no_difference("#{model}.count") do
					send(:delete,:destroy,*args)
				end
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "NAWiL should NOT get index with #{options[:login]} login" do
				login_as send(options[:login])
				get :index
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end if actions.include?(:index) || options.keys.include?(:index)

		end
	end
end
ActionController::TestCase.send(:include, NoAccessWithLogin)
