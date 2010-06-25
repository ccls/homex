# == PII (Personally Identifiable Information)
#	==	requires
#	*	subject_id
#	*	ssn ( unique and in standard format or all numbers )
#	*	state_id_no ( unique )
#	*	patid
#	*	orderno
class Pii < ActiveRecord::Base
	belongs_to :subject

	#	because subject accepts_nested_attributes for pii 
	#	we can't require subject_id on create
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :subject_id, :allow_nil => true

	validates_presence_of   :orderno
#	validates_length_of     :orderno, :is => 1
	validates_presence_of   :patid
	validates_presence_of   :stype
	validates_uniqueness_of :patid, :scope => [:orderno,:stype]

	validates_presence_of   :ssn
	validates_uniqueness_of :ssn
	validates_format_of     :ssn, :with => /\A\d{9}\z/
	validates_presence_of   :state_id_no
	validates_uniqueness_of :state_id_no
	validates_uniqueness_of :email, :allow_nil => true

	before_validation :format_ssn
	before_validation :nullify_blank_email

	def full_name
		[first_name, middle_name, last_name].join(' ')
	end

	def dob	#	overwrite default dob method for formatting
		read_attribute(:dob).try(:to_s,:dob)
	end

	def studyid
		"#{patid}-#{stype}-#{orderno}"
	end

protected

	def format_ssn
		self.ssn.to_s.gsub!(/\D/,'')
	end

	def nullify_blank_email
		#	An empty form field is not NULL to MySQL so ...
		self.email = nil if email.blank?
	end

end
