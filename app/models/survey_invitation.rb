class SurveyInvitation < ActiveRecord::Base
	belongs_to :subject
	belongs_to :response_set
	belongs_to :survey

	validates_presence_of   :subject_id
	validate                :valid_subject_id
	validates_uniqueness_of :subject_id, :scope => :survey_id
	validates_presence_of   :survey_id
	validate                :valid_survey_id
	validates_presence_of   :token
	validates_uniqueness_of :token
	validates_presence_of   :response_set_id, :on => :update
	validates_uniqueness_of :response_set_id, :allow_nil => true

	before_validation :create_token

protected

	def create_token
		return unless self.token.blank?
		#	generate random string
		#self.token = Digest::SHA1.hexdigest( 
		#			Time.now.to_s.split(//).sort_by {rand}.join )
		#	128 chars (from rake secret)
		#	activesupport-2.3.5/lib/active_support/secure_random.rb
		begin
			temp_token = ActiveSupport::SecureRandom.hex(64)
		end while SurveyInvitation.exists?(:token => temp_token)
		self.token = temp_token
	end

	def valid_subject_id
		errors.add(:subject_id,'is invalid') unless Subject.exists?(subject_id)
	end

	def valid_survey_id
		errors.add(:survey_id,'is invalid') unless Survey.exists?(survey_id)
	end

end
