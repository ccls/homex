# == PII (Personally Identifiable Information)
#	==	requires
#	*	subject_id
#	*	ssn ( unique and in standard format or all numbers )
#	*	state_id_no ( unique )
class Pii < ActiveRecord::Base
	belongs_to :subject
#	has_one :subject_type, :through => :subject
#	either way seems to work
	delegate :subject_type, :to => :subject, :allow_nil => true

	#	because subject accepts_nested_attributes for pii 
	#	we can't require subject_id on create
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :subject_id, :allow_nil => true

	validates_presence_of   :stype	#	I think this is the same as subject_type
	validates_presence_of   :orderno
	validates_length_of     :orderno, :is => 1
	validates_format_of     :orderno, :with => /\A\d\z/
	validates_presence_of   :patid
	validates_presence_of   :studyid
	validates_uniqueness_of :studyid
	validates_format_of     :studyid, :with => /\A\d+-\d*-\d+\z/
#	PatID is not unique. PatID, Type and OrderNo in combination is unique. (I still haven't renamed Type to be code friendly -- that does have to be done, however.)

	validates_presence_of   :ssn
	validates_uniqueness_of :ssn
	validates_format_of     :ssn, :with => /\A\d{9}\z/
	validates_presence_of   :state_id_no
	validates_uniqueness_of :state_id_no
	validates_uniqueness_of :email, :allow_nil => true	#, :allow_blank => true

	before_validation :format_ssn
	before_validation :generate_studyid
	before_validation :nullify_blank_email

	def full_name
		[first_name, middle_name, last_name].join(' ')
	end

	def dob	#	overwrite default dob method for formatting
		read_attribute(:dob).try(:to_s,:dob)
	end

protected

	def format_ssn
		self.ssn.to_s.gsub!(/\D/,'')
	end

	def generate_studyid
		self.studyid = "#{patid}-#{subject_type}-#{orderno}"
	end

	def nullify_blank_email
		#	An empty form field is not NULL to MySQL so ...
		self.email = nil if email.blank?
	end

end
