module RequiresValidAssociations

	def self.included(base)
		base.extend ClassMethods
#		base.send(:include,InstanceMethods)
	end

	module ClassMethods

		def assert_requires_valid_associations(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')

			associations.each do |assoc|
				assoc = assoc.to_s

				test "should require #{assoc}_id" do
					assert_difference("#{model}.count",0) do
						object = create_object("#{assoc}_id".to_sym => nil)
						assert object.errors.on(assoc.to_sym)
					end
				end

				test "should require valid #{assoc}_id" do
					assert_difference("#{model}.count",0) do
						object = create_object("#{assoc}_id".to_sym => 0)
						assert object.errors.on(assoc.to_sym)
					end
				end

			  test "should require valid #{assoc}" do
			    assert_difference("#{model}.count",0) { 
			      object = create_object(
							assoc.to_sym => Factory.build(assoc.to_sym))
			      assert object.errors.on("#{assoc}_id".to_sym)
			    }    
			  end 

			end

		end

	end

end
ActiveSupport::TestCase.send(:include,RequiresValidAssociations)
