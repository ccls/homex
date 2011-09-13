module StudySubjectsHelper

	#	Used to replace the _id_bar partial
#	def id_bar_for(study_subject,&block)
#	def study_subject_id_bar(study_subject,&block)	# TODO remove as added to ccls_engine > 3.8.7
#		stylesheets('study_subject_id_bar')
#		content_for :main do
#			"<div id='id_bar'>\n" <<
#			"<div class='childid'>\n" <<
#			"<span>ChildID:</span>\n" <<
#			"<span>#{study_subject.try(:childid)}</span>\n" <<
#			"</div><!-- class='childid' -->\n" <<
#			"<div class='studyid'>\n" <<
#			"<span>StudyID:</span>\n" <<
#			"<span>#{study_subject.try(:studyid)}</span>\n" <<
#			"</div><!-- class='studyid' -->\n" <<
#			"<div class='full_name'>\n" <<
#			"<span>#{study_subject.try(:full_name)}</span>\n" <<
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
#			"StudySubject requests no further contact with Study.\n" <<
#			"</div>\n" 
#		end if study_subject.try(:do_not_contact?)
#	end	#	id_bar_for

end
