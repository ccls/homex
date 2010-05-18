#	==	requires
#	*	address_id
#	*	subject_id
class Residence < ActiveRecord::Base
	belongs_to :address, :dependent => :destroy
	belongs_to :subject

	validates_presence_of :address, :subject

end
