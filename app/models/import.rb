# Probably won't be using this as originally
#	intended as SRC is gone.
class Import < ActiveRecord::Base	#	:nodoc:
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :first_name
		o.validates_length_of :middle_name
		o.validates_length_of :last_name
		o.validates_length_of :sex
		o.validates_length_of :language_code
		o.validates_length_of :race
		o.validates_length_of :primary_phone_number
		o.validates_length_of :alternate_phone_number
		o.validates_length_of :respondent_type
		o.validates_length_of :respondent_first_name
		o.validates_length_of :respondent_middle_name
		o.validates_length_of :respondent_last_name
		o.validates_length_of :respondent_address_line_1
		o.validates_length_of :respondent_address_line_2
		o.validates_length_of :respondent_city
		o.validates_length_of :respondent_state
		o.validates_length_of :respondent_zip
	end
end
