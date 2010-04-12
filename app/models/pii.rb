# == PII (Personally Identifiable Information)
#	==	requires
#	*	subject_id
#	*	ssn ( unique and in standard format or all numbers )
#	*	state_id_no ( unique )
class Pii < ActiveRecord::Base
	belongs_to :subject

	#	because subject accepts_nested_attributes for pii 
	#	we can't require subject_id on create
	validates_presence_of :subject_id, :on => :update
	validates_uniqueness_of :subject_id, :allow_nil => true

	validates_presence_of   :ssn
	validates_uniqueness_of :ssn
	validates_format_of     :ssn, :with => /\A\d{9}\Z/
	validates_presence_of   :state_id_no
	validates_uniqueness_of :state_id_no

	before_validation :format_ssn

	def full_name
		[first_name, middle_name, last_name].join(' ')
	end

protected

	def format_ssn
		self.ssn.to_s.gsub!(/\D/,'')
	end

end
