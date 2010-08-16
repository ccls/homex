# == PII (Personally Identifiable Information)
#	==	requires
#	*	subject_id
#	*	state_id_no ( unique )
class Pii < ActiveRecord::Base
	belongs_to :subject

	#	because subject accepts_nested_attributes for pii 
	#	we can't require subject_id on create
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :subject_id, :allow_nil => true

	validates_presence_of   :dob
	validates_presence_of   :state_id_no
	validates_uniqueness_of :state_id_no
	validates_uniqueness_of :email, :allow_nil => true
	validates_format_of :email,
	  :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
		:allow_blank => true

#	validates_format_of :phone_primary, :phone_alternate, 
#		:phone_alternate_2, :phone_alternate_3,
#	  :with => /\A\s*\(?\d{3}\)?\s*\d{3}-?\d{4}\s*\z/,
#		:allow_blank => true

	before_validation :nullify_blank_email
#	before_save :format_phones

	stringify_date :dob

	def validate
		errors.add(:dob, "is invalid") if dob_invalid?
	end

	def full_name
		[first_name, middle_name, last_name].join(' ')
	end

	def fathers_name
		[father_first_name, father_middle_name, father_last_name].join(' ')
	end

	def mothers_name
		[mother_first_name, mother_middle_name, mother_maiden_name, mother_last_name].join(' ')
	end

	def dob	#	overwrite default dob method for formatting
		#	added to_date to fix sqlite3 quirk which doesn't
		#	differentiate between times and dates.
		read_attribute(:dob).try(:to_s,:dob).try(:to_date)
	end

protected

	def nullify_blank_email
		#	An empty form field is not NULL to MySQL so ...
		self.email = nil if email.blank?
	end

#	STUPID.  .gsub!
#	or returning nil if no substitutions were performed.
#	so to correctly use gsub! you must first check the string
#	to ensure that something needs substituted or you
#	get nil for you efforts.

#	def format_phones
#		[:phone_primary, :phone_alternate, :phone_alternate_2, 
#			:phone_alternate_3].each do |phone_field|
#			unless self.send(phone_field).nil?
#				old = self.send(phone_field).gsub(/\D/,'')
#				new_phone = "(#{old[0..2]}) #{old[3..5]}-#{old[6..9]}"
#				self.send("#{phone_field}=",new_phone)
#			end
#		end
#	end

end
