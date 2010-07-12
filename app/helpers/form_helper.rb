module FormHelper

	def wrapped_spans(object_name,method,options={})
		field_wrapper(method) do
			object = instance_variable_get("@#{object_name}")
			s =  "<span class='label'>#{method}</span>\n"
			value = object.send(method)
			value = (value.to_s.blank?)?'&nbsp;':value
			s << "<span class='value'>#{value}</span>"
		end
	end

	def wrapped_text_area(object_name,method,options={})
		field_wrapper(method) do
			s =  label( object_name, method )
			s << text_area( object_name, method, options )
		end
	end

	def wrapped_text_field(object_name,method,options={})
		field_wrapper(method) do
			s =  label( object_name, method )
			s << text_field( object_name, method, options )
		end
	end

	def wrapped_check_box(object_name,method,options={})
		field_wrapper(method) do
			s =  label( object_name, method, "#{method.to_s.titleize}?" )
			s << check_box( object_name, method, options )
		end
	end

	def wrapped_collection_select(object_name,method,
		collection,value_method,text_method,options={},html_options={})
		field_wrapper(method) do
			s =  label( object_name, method )
			s << collection_select( object_name, method, 
				collection,value_method,text_method,options,html_options )
		end
	end

	def field_wrapper(method,&block)
		s =  "<div class='#{method} field_wrapper'>\n"
		s << yield
		s << "\n</div><!-- class='#{method}' -->"
	end

end

ActionView::Helpers::FormBuilder.class_eval do
	def wrapped_collection_select(method, 
		collection,value_method,text_method,options={},html_options={})
		@template.wrapped_collection_select(
			@object_name, method, collection,value_method,text_method,
				objectify_options(options),
				objectify_options(html_options))
	end
	def wrapped_check_box(method, options = {})
		@template.wrapped_check_box(
			@object_name, method, objectify_options(options))
	end
	def wrapped_text_area(method, options = {})
		@template.wrapped_text_area(
			@object_name, method, objectify_options(options))
	end
	def wrapped_text_field(method, options = {})
		@template.wrapped_text_field(
			@object_name, method, objectify_options(options))
	end
end
