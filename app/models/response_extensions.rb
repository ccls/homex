module ResponseExtensions
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			# Same as typing in the class
		end
	end
	
	module ClassMethods
	end
	
	module InstanceMethods
		#	Return an individual response's question and
		#	answer coded for Home Exposure questionnaire.
		def q_and_a_codes
			q_code = self.question.data_export_identifier
			a_code = if self.answer.response_class == "answer"
				self.answer.data_export_identifier
			else

#
#	what if response_class is "" or nil or not
#	what we need to create *_value???
#

				self.send("#{self.answer.response_class}_value")
			end
			[ q_code, a_code ]
		end
	end
end

Response.send(:include, ResponseExtensions)
