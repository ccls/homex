class Addressing < ActiveRecord::Base
	belongs_to :subject
	belongs_to :address

#	validates_presence_of :address_id, :address
	validates_presence_of :address, :on => :update
	validates_presence_of :subject_id, :subject

	accepts_nested_attributes_for :address

#	delegate :address_type,:address_type=,
#		:address_type_id, :address_type_id=,
#		:line_1,:line_2,:city,:state,:zip,:csz,
#		:line_1=,:line_2=,:city=,:state=,:zip=,
#		:to => :address, :allow_nil => true

	delegate :address_type, :address_type_id,
		:line_1,:line_2,:city,:state,:zip,:csz,
		:to => :address, :allow_nil => true

	validates_presence_of :why_invalid,  :unless => :is_valid?
	validates_presence_of :how_verified, :if => :is_verified?

	named_scope :current, :conditions => {
		:current_address => 1
	}

	named_scope :historic, :conditions => [
		'current_address IS NULL OR current_address != 1'
	]

	before_save :set_verifier, 
		:if => :is_verified?, 
		:unless => :is_verified_was
	before_save :nullify_verifier, 
		:unless => :is_verified?,
		:if => :is_verified_was
#	before_save :nullify_how_verified, :unless => :is_verified?
#	before_save :nullify_why_invalid, :if => :is_valid?

	attr_accessor :current_user

protected

	def set_verifier
		self.verified_on = Time.now
		self.verified_by_id = current_user.try(:id)||0
	end

	def nullify_verifier
		self.verified_on = nil
		self.verified_by_id = nil
	end

end
