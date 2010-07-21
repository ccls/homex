class Address < ActiveRecord::Base
	default_scope :order => 'created_at DESC'

	has_many :interviews
	has_one :residence
	belongs_to :subject
	belongs_to :address_type
	belongs_to :data_source

	validates_presence_of :subject_id, :subject
	validates_presence_of :address_type_id, :address_type
	validate :address_type_matches_line_1

	def csz
		"#{self.city}, #{self.state} #{self.zip}"
	end

protected

	def address_type_matches_line_1
		if(( line_1 =~ /p.*o.*box/i ) &&
			( address_type_id.to_s == '1' ))	#	1 is 'residence'
			errors.add(:address_type_id,
				"must not be residence") 
		end
	end

end
