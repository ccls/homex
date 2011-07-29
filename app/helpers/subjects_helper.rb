module SubjectsHelper

	#	Used to replace the _id_bar partial
#	def id_bar_for(subject,&block)
#	def subject_id_bar(subject,&block)	# TODO remove as added to ccls_engine > 3.8.7
#		stylesheets('subject_id_bar')
#		content_for :main do
#			"<div id='id_bar'>\n" <<
#			"<div class='childid'>\n" <<
#			"<span>ChildID:</span>\n" <<
#			"<span>#{subject.try(:childid)}</span>\n" <<
#			"</div><!-- class='childid' -->\n" <<
#			"<div class='studyid'>\n" <<
#			"<span>StudyID:</span>\n" <<
#			"<span>#{subject.try(:studyid)}</span>\n" <<
#			"</div><!-- class='studyid' -->\n" <<
#			"<div class='full_name'>\n" <<
#			"<span>#{subject.try(:full_name)}</span>\n" <<
#			"</div><!-- class='full_name' -->\n" <<
#			"<div class='controls'>\n" <<
##			content_for(:id_bar).to_s <<
#			@content_for_id_bar.to_s <<
#			((block_given?)?yield: '') <<
#			"</div><!-- class='controls' -->\n" <<
#			"</div><!-- id='id_bar' -->\n"
#		end
#
#		content_for :main do
#			"<div id='do_not_contact'>\n" <<
#			"Subject requests no further contact with Study.\n" <<
#			"</div>\n" 
#		end if subject.try(:do_not_contact?)
#	end	#	id_bar_for

end
