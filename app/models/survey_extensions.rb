module SurveyExtensions
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			# Same as typing in the class

			validates_uniqueness_of :access_code

		end
	end
	
	module ClassMethods
	end
	
	module InstanceMethods
		#	Override the setting of the access_code to ensure
		#	its uniqueness
		def access_code=(value)
			counter = 2
			original_value = value
			while( ( survey = Survey.find_by_access_code(value) ) && 
				( self.id != survey.id ) )
				value = [original_value,"_",counter].join
				counter += 1
			end
			super		#(value)
		end
	end
end

# Add module to Survey
Survey.send(:include, SurveyExtensions)
