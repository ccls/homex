#	==	requires
#	*	childid (unique)
#	*	subject_id (unique)
class Identifier < ActiveRecord::Base
	belongs_to :subject

#	# because subject accepts_nested_attributes for child_id
#	# we can't require subject_id on create
#	validates_presence_of   :subject, :on => :update
#	validates_uniqueness_of :subject_id, :allow_nil => true

	validates_presence_of :subject_id, :subject
	validates_uniqueness_of :subject_id

	validates_presence_of   :childid
	validates_uniqueness_of :childid

	validates_presence_of   :orderno
	validates_presence_of   :patid
	validates_presence_of   :case_control_type
	validates_uniqueness_of :patid, :scope => [:orderno,:case_control_type]

	validates_presence_of   :ssn
	validates_uniqueness_of :ssn
	validates_format_of     :ssn, :with => /\A\d{9}\z/

	before_validation :format_ssn

	def studyid
		"#{patid}-#{case_control_type}-#{orderno}"
	end

protected

	def format_ssn
		self.ssn.to_s.gsub!(/\D/,'')
	end

end
