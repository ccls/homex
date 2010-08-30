# A subject's phone number
class PhoneNumber < ActiveRecord::Base
	acts_as_list :scope => :subject_id
	belongs_to :subject
	belongs_to :phone_type

	validates_presence_of :phone_number
	validates_format_of :phone_number,
	  :with => /\A(\D*\d\D*){10}\z/
#	  :with => /\A\s*\(?\d{3}\)?\s*\d{3}-?\d{4}\s*\z/

	validates_presence_of :why_invalid,  :unless => :is_valid?
	validates_presence_of :how_verified, :if => :is_verified?

	before_save :format_phone_number

	before_save :set_verifier, 
		:if => :is_verified?, 
		:unless => :is_verified_was
	before_save :nullify_verifier, 
		:unless => :is_verified?,
		:if => :is_verified_was
#	before_save :nullify_how_verified, :unless => :is_verified?
#	before_save :nullify_why_invalid, :if => :is_valid?

	attr_accessor :current_user

protected

	def set_verifier
		self.verified_on = Time.now
		self.verified_by_id = current_user.try(:id)||0
	end

	def nullify_verifier
		self.verified_on = nil
		self.verified_by_id = nil
	end

	def format_phone_number
#		unless self.phone_number.nil?
			old = self.phone_number.gsub(/\D/,'')
			new_phone = "(#{old[0..2]}) #{old[3..5]}-#{old[6..9]}"
			self.phone_number = new_phone
#		end
	end

end
