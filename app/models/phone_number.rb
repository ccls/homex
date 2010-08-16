class PhoneNumber < ActiveRecord::Base
	acts_as_list :scope => :subject_id
	belongs_to :subject

	validates_format_of :phone_number,
	  :with => /\A\s*\(?\d{3}\)?\s*\d{3}-?\d{4}\s*\z/,
		:allow_blank => true

	before_save :format_phone_number

protected

	def format_phone_number
		unless self.phone_number.nil?
			old = self.phone_number.gsub(/\D/,'')
			new_phone = "(#{old[0..2]}) #{old[3..5]}-#{old[6..9]}"
			self.phone_number = new_phone
		end
	end

end
