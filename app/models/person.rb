# don't know exactly
class Person < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

#	belongs_to :context
	has_many :interviews, :foreign_key => 'interviewer_id'

	has_many :organizations

	validates_presence_of :last_name
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :first_name
		o.validates_length_of :last_name
		o.validates_length_of :honorific
	end

	#	Returns string containing first and last name
	def full_name
		"#{first_name} #{last_name}"
	end

	#	Returns full_name
	def to_s
		full_name
	end

end
