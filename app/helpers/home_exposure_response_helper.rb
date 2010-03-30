require 'action_view/helpers/form_options_helper'

module HomeExposureResponseHelper

#	ActionView::Helpers::FormBuilder.class_eval do
##		@@he_question_counter = 1
##		def abcs 
##			return "abcdefghijklmnopqrstuvwxyz".split('')
##		end
#
##		def her_select(method, choices=[], options = {}, html_options = {})
##			if choices.empty?
##				class_options = HomeExposureResponse.send("#{method}_options")
##				if class_options.is_a?(Array)
##					choices = class_options 
##					label = nil
##				else
##					choices = class_options[:answers]
##					label = class_options[:question]
##				end
##			end
##			@template.label(@object_name, method, label ) << "<br/>" <<
##			@template.select(@object_name, method, 
##				choices, 
##				options.merge({ :include_blank => '- select -' }),
##				html_options)
##		end
#
#		def he_question(qanda)	#, index=1)
#			s = "<p>"
##			s << "#{index}. #{qanda[:question]} <br/>"
#			s << "#{qanda[:question]} <br/>"
#			if qanda[:variable].blank?
#				if !qanda[:answers].blank? &&
#					qanda[:answers].is_a?(Array) &&
#					qanda[:answers][0].is_a?(Hash)
##					qanda[:answers].each_with_index{|qa,i|
##						s << self.he_question(qa,"#{index}#{abcs[i]}")
#					qanda[:answers].each{|qa|
#						s << self.he_question(qa)
#					}
#				end
#			else
#				case 
#					when qanda[:answers].blank?
#						s << @template.text_field(@object_name, qanda[:variable])
#					when qanda[:answers].is_a?(Array) &&
#						qanda[:answers][0].is_a?(Array)
#						s << @template.select(@object_name, 
#							qanda[:variable], qanda[:answers],
#							{ :include_blank => '- select -' } )
#					when qanda[:answers].is_a?(Array) &&
#						qanda[:answers][0].is_a?(Hash)
#						s << qanda[:answers].collect{|qa|
#							self.he_question(qa)
#						}
#					else 
#						s << "I don't know what to do with that"
#				end 
#			end
#			s << "</p>"
#			s
#		end
#
#	end	#	ActionView::Helpers::FormBuilder.class_eval do

end
