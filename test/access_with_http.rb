module AccessWithHttp

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def awihttp_title(options={})
			"with #{options[:login]} login#{options[:suffix]}"
		end

		def assert_access_with_http(*actions)
			user_options = actions.extract_options!

			options = {
				:login => :admin 
			}
			if ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)


			test "AWiHTTP should get new #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args = options[:new] || {}
				send(:get,:new,args)
				assert_response :success
				assert_template 'new'
				assert assigns(options[:factory])
				assert_nil flash[:error]
			end if actions.include?(:new) || options.keys.include?(:new)

			test "AWiHTTP should post create #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				model = options[:factory].to_s.camelize
				args = if options[:create]
					options[:create]
				else
					{options[:factory] => Factory.attributes_for(options[:factory])}
				end
				assert_difference("#{model}.count",1) do
					send(:post,:create,args)
				end
				assert_response :redirect
				assert_nil flash[:error]
			end if actions.include?(:create) || options.keys.include?(:create)

			test "AWiHTTP should get edit #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args={}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
				end
				send(:get,:edit, args)
				assert_response :success
				assert_template 'edit'
				assert assigns(options[:factory])
				assert_nil flash[:error]
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "AWiHTTP should put update #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args={}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
					args[options[:factory]] = Factory.attributes_for(options[:factory])
				end
				before = obj.updated_at
				send(:put,:update, args)
				after = obj.reload.updated_at
				assert_not_equal before,after
				assert_response :redirect
				assert_nil flash[:error]
			end if actions.include?(:update) || options.keys.include?(:update)

			test "AWiHTTP should get show #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args={}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
				end
				send(:get,:show, args)
				assert_response :success
				assert_template 'show'
				assert assigns(options[:factory])
				assert_nil flash[:error]
			end if actions.include?(:show) || options.keys.include?(:show)

			test "AWiHTTP should delete destroy #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				model = options[:factory].to_s.camelize
				args={}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
				end
				assert_difference("#{model}.count",-1) do
					send(:delete,:destroy,args)
				end
				assert_response :redirect
				assert assigns(options[:factory])
				assert_nil flash[:error]
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "AWiHTTP should get index #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				get :index
				assert_response :success
				assert_template 'index'
				unless options[:factory].blank?
					assert assigns(options[:factory].to_s.pluralize.to_sym)
				end
				assert_nil flash[:error]
			end if actions.include?(:index) || options.keys.include?(:index)

			test "AWiHTTP should get index #{awihttp_title(options)} and items" do
				turn_https_off
				send(options[:before]) if !options[:before].blank?
				login_as send(options[:login])
				3.times{ Factory(options[:factory]) } if !options[:factory].blank?
				get :index
				assert_response :success
				assert_template 'index'
				unless options[:factory].blank?
					f = options[:factory].to_s.pluralize.to_sym
					assert assigns(f)
				end
				assert_nil flash[:error]
			end if actions.include?(:index) || options.keys.include?(:index)

		end

	end

end
ActionController::TestCase.send(:include, AccessWithHttp)
