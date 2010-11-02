#	==	requires
#	*	childid (unique)
#	*	patid (unique)
class Export < ActiveRecord::Base	#	:nodoc:
	validates_presence_of   :childid
	validates_uniqueness_of :childid
	validates_presence_of   :patid
	validates_uniqueness_of :patid
	validates_length_of :first_name, :middle_name, 
		:last_name, :type, :orderno, :mother_first_name,
		:mother_middle_name, :mother_last_name, :father_first_name,
		:father_middle_name, :father_last_name, :hospital_code,
		:maximum => 250, :allow_blank => true
end
