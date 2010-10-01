module ActiveRecordExtension
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods

		def random
			count = count()
			if count > 0
				first(:offset => rand(count))
			else
				nil
			end
		end

		def validates_absence_of(*attr_names)
			configuration = { :on => :save }
			configuration.update(attr_names.extract_options!)

			send(validation_method(configuration[:on]), configuration) do |record|
				attr_names.each do |attr_name|
					unless record.send(attr_name).blank?
						record.errors.add(attr_name, configuration[:message])
					end
				end
			end
		end

	end

end
ActiveRecord::Base.send(:include,ActiveRecordExtension)
