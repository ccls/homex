#	==	requires
#	*	address_id
#	*	subject_id
class Residence < ActiveRecord::Base
	belongs_to :address
	belongs_to :subject

	validates_presence_of :address_id
	validate              :valid_address_id
	validates_presence_of :subject_id
	validate              :valid_subject_id

protected

	def valid_address_id
		errors.add(:address_id,'is invalid') unless Address.exists?(address_id)
	end

	def valid_subject_id
		errors.add(:subject_id,'is invalid') unless Subject.exists?(subject_id)
	end

end
