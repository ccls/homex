module AccessWithLogin

	def self.included(base)
		base.extend ClassMethods
		base.send(:include,InstanceMethods)
	end

	module ClassMethods

		def awil_title
			"with #{@options[:login]} login#{@options[:suffix]}"
		end

		def assert_access_with_login(actions=[],options={})

			@options = options

			test "AWiL should get new #{awil_title}" do
				login_as send(options[:login])
				args = options[:new] || {}
				send(:get,:new,args)
				assert_response :success
				assert_template 'new'
				assert assigns(options[:factory])
				assert_nil flash[:error]
			end if actions.include?(:new) || options.keys.include?(:new)

			test "AWiL should post create #{awil_title}" do
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

			test "AWiL should get edit #{awil_title}" do
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

			test "AWiL should put update #{awil_title}" do
				login_as send(options[:login])
				args={}
				if options[:factory]
					obj = Factory(options[:factory])
					args[:id] = obj.id
					args[options[:factory]] = Factory.attributes_for(options[:factory])
				end
				send(:put,:update, args)
				assert_response :redirect
				assert_nil flash[:error]
			end if actions.include?(:update) || options.keys.include?(:update)

			test "AWiL should get show #{awil_title}" do
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

			test "AWiL should delete destroy #{awil_title}" do
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

			test "AWiL should get index #{awil_title}" do
				login_as send(options[:login])
				get :index
				assert_response :success
				assert_template 'index'
				unless options[:factory].blank?
					assert assigns(options[:factory].to_s.pluralize.to_sym)
				end
				assert_nil flash[:error]
			end if actions.include?(:index) || options.keys.include?(:index)

			test "AWiL should get index #{awil_title} and items" do
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

	module InstanceMethods

	end
end
ActionController::TestCase.send(:include, AccessWithLogin)
