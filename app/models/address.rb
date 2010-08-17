class Address < ActiveRecord::Base
	default_scope :order => 'created_at DESC'

	has_many :interviews
	has_one :residence
	belongs_to :subject
	belongs_to :address_type
	belongs_to :data_source

#	belongs_to :verified_by, :class_name => 'User'

	validates_presence_of :subject_id, :subject
	validates_presence_of :address_type_id, :address_type
	validate :address_type_matches_line_1

	validates_presence_of :line_1, :city, :state, :zip

#	The dummy data loaded with the rake task has some
#	broken and invalid addresses so must relax the
#	validations when loading them.

	validates_format_of :zip,
#		:allow_blank => true,
		:with => /\A\s*\d{5}(-\d{4})?\s*\z/,
		:message => "should be 12345 or 12345-1234"

	before_save :format_zip

	def csz
		"#{self.city}, #{self.state} #{self.zip}"
	end

protected

	def address_type_matches_line_1
		#	It is inevitable that this will match too much
		if(( line_1 =~ /p.*o.*box/i ) &&
			( address_type_id.to_s == '1' ))	#	1 is 'residence'
			errors.add(:address_type_id,
				"must not be residence with PO Box") 
		end
	end

	def format_zip
#		self.zip.to_s.gsub!(/\D/,'')
#	force some common format here .....
		self.zip.squish! unless zip.blank?
	end

end
