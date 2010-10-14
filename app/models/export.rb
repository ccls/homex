#	==	requires
#	*	childid (unique)
#	*	patid (unique)
class Export < ActiveRecord::Base	#	:nodoc:
	validates_presence_of   :childid
	validates_uniqueness_of :childid
	validates_presence_of   :patid
	validates_uniqueness_of :patid
end
