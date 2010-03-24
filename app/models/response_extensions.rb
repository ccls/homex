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
		#	Error for when answer's response_class is not in
		#	( answer string integer float text date time datetime )
		class InvalidResponseClass < StandardError; end

		#	Return an individual response's question and
		#	answer coded for Home Exposure questionnaire.
		def q_and_a_codes
			q_code = self.question.data_export_identifier

			unless %w( answer string integer float
					text date time datetime
				).include?(self.answer.response_class)
				raise InvalidResponseClass
			end

			a_code = if self.answer.response_class == "answer"
				self.answer.data_export_identifier
			else
				self.send("#{self.answer.response_class}_value")
			end
			[ q_code, a_code ]
		end
	end
end

Response.send(:include, ResponseExtensions)
