# yet another rails forget
load 'subject.rb' if RAILS_ENV == 'development'
module ResponseSetExtensions	#	:nodoc:
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			belongs_to :subject, :counter_cache => true, :foreign_key => 'study_subject_id'
			has_one :survey_invitation
			validates_presence_of :study_subject_id
		end
	end
	
	module ClassMethods	#	:nodoc:
	end
	
	module InstanceMethods
		# Convert response set to a home exposure questionnaire.
		def to_her
			HomeExposureResponse.create({
				:study_subject_id => self.study_subject_id
			}.merge(self.q_and_a_codes_as_attributes))
		end
	end
end
