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

	before_validation :nullify_blank_email

	stringify_date :dob
	validate :dob_is_valid

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

	def dob_is_valid
		errors.add(:dob, "is invalid") if dob_invalid?
	end

	def nullify_blank_email
		#	An empty form field is not NULL to MySQL so ...
		self.email = nil if email.blank?
	end

end
