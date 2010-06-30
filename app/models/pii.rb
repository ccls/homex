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

	before_validation :nullify_blank_email

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
		read_attribute(:dob).try(:to_s,:dob)
	end

protected

	def nullify_blank_email
		#	An empty form field is not NULL to MySQL so ...
		self.email = nil if email.blank?
	end

end
