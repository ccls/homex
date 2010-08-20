class Addressing < ActiveRecord::Base
	belongs_to :subject
	belongs_to :address

#	validates_presence_of :address_id, :address
	validates_presence_of :address, :on => :update
	validates_presence_of :subject_id, :subject

	#	because subject accepts_nested_attributes for pii 
	#	we can't require subject_id on create
#	validates_presence_of   :subject, :on => :update
#	validates_uniqueness_of :subject_id, :allow_nil => true


	accepts_nested_attributes_for :address

#	delegate :address_type,:address_type=,
#		:address_type_id, :address_type_id=,
#		:line_1,:line_2,:city,:state,:zip,:csz,
#		:line_1=,:line_2=,:city=,:state=,:zip=,
#		:to => :address, :allow_nil => true

	delegate :address_type, :address_type_id,
		:line_1,:line_2,:city,:state,:zip,:csz,
		:to => :address, :allow_nil => true

end
