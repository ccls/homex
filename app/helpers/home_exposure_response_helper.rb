module HomeExposureResponseHelper

	def show_row(object_name,method,options={})
		s = "<tr class='row'><td>#{method.to_s.titleize}:</td><td>"
		value = if options[:value]
			options[:value]
		else
			object = instance_variable_get("@#{object_name}")
			value = object.send(method)
			value = (value.to_s.blank?)?'&nbsp;':h(value.to_s)
		end
		s << value
		s << "</td><td>"
#		s << answer_text(method,value)
#	TODO create decoded in HER model
#		s << send("decode_#{something or other}") if somethingorother
#		s << HER.decode_answer(method,value)
#		HER.decode_answer finds the "method" which is the question's field_name
#			in the field_names from config file, sees if it is "coded" and then
#			returns the decoded answer text, otherwise just the value?
		s << "</td></tr>"
	end

##	TODO remove this method after the creation of the aforementioned decoders
#	def answer_text(method,value)
#		return '' if value.blank? or value == '&nbsp;'
#		require 'question'
#		require 'answer'
#		q = Question.find_by_data_export_identifier(method)
#		if q.nil?
#			'question not found?'
#		else
#			a = q.answers.find_by_data_export_identifier(value)
##			if a.nil?
##				"answer not found with value #{value}"
##			else
##				a.text
##			end
##			(a.nil?) ? '&nbsp;' : a.text 
#			(a.nil?) ? '' : a.text 
#		end
#	end

#	TODO at some point these decoders may better serve in the HER model itself???

	def decode_yndk(value)
		case value.to_i
			when 1   then "1 = Yes"
			when 2   then "2 = No"
			when 999 then "9 = Don't Know"
			else '&nbsp;'
		end
	end

	def decode_osrn(value)
		case value.to_i
			when 1 then "1 = Often"
			when 2 then "2 = Sometimes"
			when 3 then "3 = Rarely"
			when 4 then "4 = Never"
			else '&nbsp;'
		end
	end

	def decode_freq1(value)
		case value.to_i
			when 1   then "1 = Every day (or almost every day)"
			when 2   then "2 = 1-2 times per week"
			when 3   then "3 = 1-2 times per month"
			when 4   then "4 = less than one time per month"
			when 5   then "5 = Never"
			when 999 then "9 = Don't Know"
			else '&nbsp;'
		end
	end

	def decode_freq2(value)
		case value.to_i
			when 1   then "1 = Every day or almost everyday"
			when 2   then "2 = About once a week"
			when 3   then "3 = A few times a month"
			when 4   then "4 = A few times a year"
			when 5   then "5 = Never"
			when 999 then "9 = Don't Know"
			else '&nbsp;'
		end
	end

	def decode_freq3(value)
		case value.to_i
			when 1   then "1 = Less than once a month"
			when 2   then "2 = 1-3 times a month"
			when 3   then "3 = Once a week"
			when 4   then "4 = More than once a week"
			when 999 then "9 = Don't Know"
			else '&nbsp;'
		end
	end

	def decode_quantity(value)
		case value.to_i
			when 1   then "1 = 0"
			when 2   then "2 = 1-2"
			when 3   then "3 = 3-5"
			when 4   then "4 = More than 5"
			when 999 then "9 = Don't Know"
			else '&nbsp;'
		end
	end

	def decode_doneness(value)
		case value.to_i
			when 1   then "1 = Not browned"
			when 2   then "2 = Lightly-browned"
			when 3   then "3 = Well-browned"
			when 4   then "4 = Black or charred"
			when 5   then "5 = It varies (volunteered code)"
			when 999 then "9 = Don't Know"
			else '&nbsp;'
		end
	end

	def decode_residence(value)
		case value.to_i
			when 1   then "1 = Single family residence"
			when 2   then "2 = Duplex / Townhouse"
			when 3   then "3 = Apartment / Condominium"
			when 4   then "4 = Mobile Home"
			when 8   then "8 = Other (specify)"
			when 999 then "9 = Don't Know"
			else '&nbsp;'
		end
	end

	def decode_material(value)
		case value.to_i
			when 1   then "1 = Wood"
			when 2   then "2 = Mason / Brick / Cement"
			when 3   then "3 = Pre-fabricated panels"
			when 8   then "8 = Something Else (specify)"
			when 999 then "9 = Don't Know"
			else '&nbsp;'
		end
	end

	def decode_percent(value)
		case value.to_i
			when 1   then "1 = Less than 25%"
			when 2   then "2 = 25% - 49%"
			when 3   then "3 = 50% - 74%"
			when 4   then "4 = 75% - 100%"
			when 999 then "9 = Don't Know"
			else '&nbsp;'
		end
	end

	def decode_five(value)
		case value.to_i
			when 1 then "1 = 5 or more time"
			when 2 then "2 = Fewer than 5 times"
			else '&nbsp;'
		end
	end

	def decode_hours(value)
		case value.to_i
			when 1   then "1 = less than one hour per day"
			when 2   then "2 = 1-2 hours per day"
			when 3   then "3 = 3-6 hours per day"
			when 4   then "4 = More than 6 hours per day"
			when 999 then "9 = Don't Know"
			else '&nbsp;'
		end
	end

	def decode_(value)
		value
	end

end
