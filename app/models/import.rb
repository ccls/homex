# Probably won't be using this as originally
#	intended as SRC is gone.
class Import < ActiveRecord::Base	#	:nodoc:
	validates_length_of :first_name, 
		:middle_name, :last_name, :sex, :language_code, :race,
		:primary_phone_number, :alternate_phone_number, :respondent_type,
		:respondent_first_name, :respondent_middle_name, :respondent_last_name,
		:respondent_address_line_1, :respondent_address_line_2,
		:respondent_city, :respondent_state, :respondent_zip,
		:maximum => 250, :allow_blank => true
end
