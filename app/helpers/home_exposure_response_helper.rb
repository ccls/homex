#require 'action_view/helpers/form_options_helper'
module HomeExposureResponseHelper

	def show_row(object_name,method,options={})
		s = "<tr><td>#{method.to_s.titleize}:</td><td>"
		value = if options[:value]
			options[:value]
		else
			object = instance_variable_get("@#{object_name}")
			value = object.send(method)
			value = (value.to_s.blank?)?'&nbsp;':h(value.to_s)
		end
		s << value
		s << "</td></tr>"
	end

end
