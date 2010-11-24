#	==	requires
#	*	childid (unique)
#	*	patid (unique)
class Export < ActiveRecord::Base	#	:nodoc:
	validates_presence_of   :childid
	validates_uniqueness_of :childid
	validates_presence_of   :patid
	validates_uniqueness_of :patid
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :first_name
		o.validates_length_of :middle_name
		o.validates_length_of :last_name
		o.validates_length_of :type
		o.validates_length_of :orderno
		o.validates_length_of :mother_first_name
		o.validates_length_of :mother_middle_name
		o.validates_length_of :mother_last_name
		o.validates_length_of :father_first_name
		o.validates_length_of :father_middle_name
		o.validates_length_of :father_last_name
		o.validates_length_of :hospital_code
	end
end
