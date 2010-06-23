# == PII (Personally Identifiable Information)
#	==	requires
#	*	subject_id
#	*	ssn ( unique and in standard format or all numbers )
#	*	state_id_no ( unique )
class Pii < ActiveRecord::Base
	belongs_to :subject
#	has_one :subject_type, :through => :subject
#	either way seems to work
	delegate :subject_type, :to => :subject

	#	because subject accepts_nested_attributes for pii 
	#	we can't require subject_id on create
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :subject_id, :allow_nil => true

	validates_presence_of   :stype	#	I think this is the same as subject_type
	validates_presence_of   :orderno
	validates_length_of     :orderno, :is => 1
	validates_format_of     :orderno, :with => /\d/
	validates_presence_of   :patid
	validates_uniqueness_of :patid, :scope => [:stype,:orderno]	#	TODO
#	PatID is not unique. PatID, Type and OrderNo in combination is unique. (I still haven't renamed Type to be code friendly -- that does have to be done, however.)

	validates_presence_of   :ssn
	validates_uniqueness_of :ssn
	validates_format_of     :ssn, :with => /\A\d{9}\Z/
	validates_presence_of   :state_id_no
	validates_uniqueness_of :state_id_no
	validates_uniqueness_of :email, :allow_nil => true

	before_validation :format_ssn

	def full_name
		[first_name, middle_name, last_name].join(' ')
	end

	def dob	#	overwrite default dob method for formatting
		read_attribute(:dob).try(:to_s,:dob)
	end

	def studyid
		"#{patid}-#{subject_type}-#{orderno}"
	end

protected

	def format_ssn
		self.ssn.to_s.gsub!(/\D/,'')
	end

end
