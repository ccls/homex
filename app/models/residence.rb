#	==	requires
#	*	address_id
#	*	subject_id
class Residence < ActiveRecord::Base
	belongs_to :address
	belongs_to :subject

	validates_presence_of :address_id
	validates_presence_of :subject_id
end
