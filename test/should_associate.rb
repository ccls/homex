module ShouldAssociate

	def self.included(base)
		base.extend ClassMethods
#		base.send(:include,InstanceMethods)
	end

	module ClassMethods

		def assert_should_belong_to(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			associations.each do |assoc|
				assoc = assoc.to_s

				test "SA should belong to #{assoc}" do
					object = create_object
					assert_nil object.send(assoc)
					object.send("#{assoc}=",Factory(assoc))
					assert_not_nil object.send(assoc)
				end

			end

		end

		def assert_should_have_many_(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			associations.each do |assoc|
				assoc = assoc.to_s

				test "SA should have many #{assoc}" do
					object = create_object
					assert_equal 0, object.send(assoc).length
					Factory(assoc.singularize, 
						"#{model.underscore}_id".to_sym => object.id)
#	doesn't work for all
#object.send(assoc) << Factory(assoc.singularize)
					assert_equal 1, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 1, object.reload.send("#{assoc}_count")
					end
					Factory(assoc.singularize, 
						"#{model.underscore}_id".to_sym => object.id)
					assert_equal 2, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 2, object.reload.send("#{assoc}_count")
					end
				end

			end

		end
		alias_method :assert_should_have_many, 
			:assert_should_have_many_
		alias_method :assert_should_have_many_associations, 
			:assert_should_have_many_

	end

end
ActiveSupport::TestCase.send(:include,ShouldAssociate)
