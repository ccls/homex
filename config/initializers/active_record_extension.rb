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

		def validates_complete_date_for(*attr_names)
			configuration = { :on => :save,
				:message => "is not a complete date." }
			configuration.update(attr_names.extract_options!)

			attr_names.each do |attr_name|
				attr_accessor "#{attr_name}_incomplete".to_sym
				define_method "#{attr_name}=" do |value|
					super
				end
				define_method "#{attr_name}_with_completion=" do |value|
					incomplete = case value
						when String
							date_hash = Date._parse(value)
							if date_hash.has_key?(:year) &&
								date_hash.has_key?(:mon) &&
								date_hash.has_key?(:mday)
								false
							else
								true
							end
						when Time then false
						when Date then false
						when NilClass then !configuration[:allow_nil]
						else false
					end
					send("#{attr_name}_incomplete=",incomplete)
					send("#{attr_name}_without_completion=",value)
				end
				alias_method_chain "#{attr_name}=".to_sym, :completion
			end

			send(validation_method(configuration[:on]), configuration) do |record|
				attr_names.each do |attr_name|
					if record.send("#{attr_name}_incomplete").true?
						record.errors.add(attr_name, configuration[:message])
					end
				end
			end
		end

	end

end
ActiveRecord::Base.send(:include,ActiveRecordExtension)
