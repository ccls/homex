module AccessWithLogin

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def assert_access_with_login(actions=[],options={})

			test "AWiL should get new with #{options[:login]} login" do
				login_as send(options[:login])
				get :new
				assert_response :success
				assert_template 'new'
				assert assigns(options[:factory])
			end if actions.include?(:new) || options.keys.include?(:new)

			test "AWiL should post create with #{options[:login]} login" do
				login_as send(options[:login])
#				args = {}
				model = options[:factory].to_s.camelize
#				args[model] = if options[:create]
				args = if options[:create]
					options[:create]
				else
					{options[:factory] => Factory.attributes_for(options[:factory])}
				end
				assert_difference("#{model}.count",1) do
					send(:post,:create,args)
				end
				assert_response :redirect
			end if actions.include?(:create) || options.keys.include?(:create)

			test "AWiL should get edit with #{options[:login]} login" do
				login_as send(options[:login])
				args=[]
				if options[:factory]
					obj = Factory(options[:factory])
					args.push(:id => obj.id)
				end
				send(:get,:edit, *args)
				assert_response :success
				assert_template 'edit'
				assert assigns(options[:factory])
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "AWiL should put update with #{options[:login]} login" do
				login_as send(options[:login])
				args={}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
					args[options[:factory]] = Factory.attributes_for(options[:factory])
				end
				send(:put,:update, args)
				assert_response :redirect
			end if actions.include?(:update) || options.keys.include?(:update)

			test "AWiL should get show with #{options[:login]} login" do
				login_as send(options[:login])
				args=[]
				if options[:factory]
					obj = Factory(options[:factory])
					args.push(:id => obj.id)
				end
				send(:get,:show, *args)
				assert_response :success
				assert_template 'show'
				assert assigns(options[:factory])
			end if actions.include?(:show) || options.keys.include?(:show)

			test "AWiL should delete destroy with #{options[:login]} login" do
				login_as send(options[:login])
				model = options[:factory].to_s.camelize
				args=[]
				if options[:factory]
					obj = Factory(options[:factory])
					args.push(:id => obj.id)
				end
				assert_difference("#{model}.count",-1) do
					send(:delete,:destroy,*args)
				end
				assert_response :redirect
				assert assigns(options[:factory])
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "AWiL should get index with #{options[:login]} login" do
				login_as send(options[:login])
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(options[:factory].to_s.pluralize.to_sym)
			end if actions.include?(:index) || options.keys.include?(:index)

		end
	end
end
ActionController::TestCase.send(:include, AccessWithLogin)
