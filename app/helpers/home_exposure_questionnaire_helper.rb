require 'action_view/helpers/form_options_helper'

module HomeExposureQuestionnaireHelper

	ActionView::Helpers::FormBuilder.class_eval do
		def heq_select(method, choices=[], options = {}, html_options = {})
			if choices.empty?
				class_options = HomeExposureQuestionnaire.send("#{method}_options")
				if class_options.is_a?(Array)
					choices = class_options 
					label = nil
				else
					choices = class_options[:answers]
					label = class_options[:question]
				end
			end
			@template.label(@object_name, method, label ) << "<br/>" <<
			@template.select(@object_name, method, 
				choices, 
				options.merge({ :include_blank => '- select -' }),
				html_options)
		end
	end

end
