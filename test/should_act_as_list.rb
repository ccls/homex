module ShouldActAsList

	def self.included(base)
		base.extend ClassMethods
#		base.send(:include,InstanceMethods)
	end

	module ClassMethods

		def assert_should_act_as_list

			test "should act as list" do
				model = create_object.class.name
				model.constantize.destroy_all
				object = create_object
				assert_equal 1, object.position
				object = create_object
				assert_equal 2, object.position

				# gotta be a relative test as there may already
				# by existing objects (unless I destroy them)
				assert_difference("#{model}.last.position",1) do
					create_object
				end
			end

		end

	end

end
ActiveSupport::TestCase.send(:include,ShouldActAsList)
