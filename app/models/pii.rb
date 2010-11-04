# == PII (Personally Identifiable Information)
#	==	requires
#	*	subject_id
#	*	state_id_no ( unique )
class Pii < ActiveRecord::Base
	belongs_to :subject, :foreign_key => 'study_subject_id'

	#	because subject accepts_nested_attributes for pii 
	#	we can't require subject_id on create
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :study_subject_id, :allow_nil => true

	validates_presence_of   :dob
	validates_presence_of   :state_id_no
	validates_uniqueness_of :state_id_no
	validates_uniqueness_of :email, :allow_nil => true
	validates_format_of :email,
	  :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
		:allow_blank => true

	before_validation :nullify_blank_email

	validates_complete_date_for :dob, :died_on,
		:allow_nil => true

	validates_length_of :state_id_no,
		:first_name, :middle_name, :last_name,
		:father_first_name, :father_middle_name, :father_last_name,
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:maximum => 250, :allow_blank => true

	#	Returns string containing subject's first, middle and last name
	def full_name
		[first_name, middle_name, last_name].join(' ')
	end

	#	Returns string containing subject's father's first, middle and last name
	def fathers_name
		[father_first_name, father_middle_name, father_last_name].join(' ')
	end

	#	Returns string containing subject's mother's first, middle and last name
	def mothers_name
		[mother_first_name, mother_middle_name, mother_maiden_name, mother_last_name].join(' ')
	end

	#	I don't know if I still need this
	#	commented out 20101014
	#	uncommented 20101014
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

end
