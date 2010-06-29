#	==	requires
#	*	address_id
class Residence < ActiveRecord::Base
	belongs_to :address
	validates_presence_of :address
end
