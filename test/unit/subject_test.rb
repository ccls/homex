require File.dirname(__FILE__) + '/../test_helper'

class SubjectTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:race,:subject_type)
	assert_should_have_many(:survey_invitations,:addresses,
		:operational_events,:enrollments, :samples,:response_sets)
	assert_should_initially_belong_to(:race,:subject_type,:vital_status)
	assert_should_have_one(:pii,:patient,:home_exposure_response,
		:identifier)
	assert_should_require(:subjectid)
	assert_should_require_unique(:subjectid)

	test "should create subject" do
		assert_difference( 'Race.count' ){
		assert_difference( 'SubjectType.count' ){
		assert_difference( 'Subject.count' ){
			subject = create_subject
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should create subject with pii" do
		assert_difference( 'Pii.count', 1) {
		assert_difference( 'Subject.count', 1) {
			subject = create_subject(
				:pii_attributes => Factory.attributes_for(:pii))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create subject with second pii" do
		assert_difference( 'Pii.count', 1) {
		assert_difference( 'Subject.count', 1) {
			subject = create_subject(
				:pii_attributes => Factory.attributes_for(:pii))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			subject.update_attributes(
				:pii_attributes => Factory.attributes_for(:pii))
			assert subject.errors.on('pii.subject_id')
		} }
	end

	test "should NOT create subject with empty pii" do
		assert_difference( 'Pii.count', 0) {
		assert_difference( 'Subject.count', 0) {
			subject = create_subject( :pii_attributes => {})
			assert subject.errors.on('pii.state_id_no')
		} }
	end

	test "should create subject with patient" do
		assert_difference( 'Patient.count', 1) {
		assert_difference( 'Subject.count', 1) {
			subject = create_subject(
				:patient_attributes => Factory.attributes_for(:patient))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create subject with second patient" do
		assert_difference( 'Patient.count', 1) {
		assert_difference( 'Subject.count', 1) {
			subject = create_subject(
				:patient_attributes => Factory.attributes_for(:patient))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			subject.update_attributes(
				:patient_attributes => Factory.attributes_for(:patient))
			assert subject.errors.on('patient.subject_id')
		} }
	end

#	test "should NOT create subject with empty patient" do
#
##	patient has no requirements so it would actually work
##	TODO
#
#		pending
#
#	end

	test "should create subject with identifier" do
		assert_difference( 'Identifier.count', 1) {
		assert_difference( 'Subject.count', 1) {
			subject = create_subject(
				:identifier_attributes => Factory.attributes_for(:identifier))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create subject with second identifier" do
		assert_difference( 'Identifier.count', 1) {
		assert_difference( 'Subject.count', 1) {
			subject = create_subject(
				:identifier_attributes => Factory.attributes_for(:identifier))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			subject.update_attributes(
				:identifier_attributes => Factory.attributes_for(:identifier))
			assert subject.errors.on('identifier.subject_id')
		} }
	end

	test "should NOT create subject with empty identifier" do
		assert_difference( 'Identifier.count', 0) {
		assert_difference( 'Subject.count', 0) {
			subject = create_subject(
				:identifier_attributes => {} )
			assert subject.errors.on('identifier.childid')
		} }
	end

	test "studyid should be patid, case_control_type and orderno" do
		subject = create_subject(
			:identifier_attributes => Factory.attributes_for(:identifier, 
				:case_control_type => 'A',
				:patid   => '123',
				:orderno => '4'
		))
		assert_equal "123-A-4", subject.reload.studyid
	end

	test "should pad subjectid with leading zeros" do
		subject = Factory.build(:subject)
		assert subject.subjectid.length < 6
		subject.save
		assert subject.subjectid.length == 6
	end

	test "should belong to vital_status" do
		subject = create_subject(:vital_status => nil)
		assert_nil subject.vital_status
		subject.vital_status = Factory(:vital_status)
		assert_not_nil subject.vital_status
	end

	test "should belong to hispanicity" do
		subject = create_subject
pending
#		assert_nil subject.vital_status
#		subject.vital_status = Factory(:vital_status)
#		assert_not_nil subject.vital_status
	end

	def sscount(subject_id,survey_id)
		SurveyInvitation.count(:conditions => {
			:subject_id => subject_id, :survey_id => survey_id })
	end

	test "should have one survey_invitation per survey" do
		subject = create_subject
		survey  = Factory(:survey)
		assert_difference("sscount(#{subject.id},#{survey.id})",1){
			Factory(:survey_invitation, {
				:subject_id => subject.id, :survey_id => survey.id })
		}
		assert_difference("sscount(#{subject.id},#{survey.id})",0){
		assert_raise(ActiveRecord::RecordInvalid){
			Factory(:survey_invitation, {
				:subject_id => subject.id, :survey_id => survey.id })
		} }
	end

	test "her_invitation should return home_exposure_survey invitation" do
		subject = create_subject
		assert_nil subject.her_invitation
		si = Factory(:survey_invitation, 
			:subject => subject,
			:survey  => Survey.first)
		assert_not_nil subject.her_invitation
	end

	test "should NOT destroy survey_invitations with subject" do
		subject = create_subject
		Factory(:survey_invitation, :subject_id => subject.id)
		Factory(:survey_invitation, :subject_id => subject.id)
		assert_difference('Subject.count',-1) {
		assert_difference('SurveyInvitation.count',0) {
			subject.destroy
		} }
	end

#	test "should NOT destroy dust_kit with subject" do
#		subject = create_subject
#		Factory(:dust_kit, :subject_id => subject.id)
#		assert_difference('Subject.count',-1) {
#		assert_difference('DustKit.count',0) {
#			subject.destroy
#		} }
#	end

	test "should NOT destroy identifier with subject" do
		subject = create_subject
		Factory(:identifier, :subject_id => subject.id)
		assert_difference('Subject.count',-1) {
		assert_difference('Identifier.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy pii with subject" do
		subject = create_subject
		Factory(:pii, :subject_id => subject.id)
		assert_difference('Subject.count',-1) {
		assert_difference('Pii.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy patient with subject" do
		subject = create_subject
		Factory(:patient, :subject_id => subject.id)
		assert_difference('Subject.count',-1) {
		assert_difference('Patient.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy home_exposure_response with subject" do
		subject = create_subject
		Factory(:home_exposure_response, :subject_id => subject.id)
		assert_difference('Subject.count',-1) {
		assert_difference('HomeExposureResponse.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy addresses with subject" do
		subject = create_subject
		Factory(:address, :subject_id => subject.id)
		Factory(:address, :subject_id => subject.id)
		assert_difference('Subject.count',-1) {
		assert_difference('Address.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy operational_events with subject" do
		subject = create_subject
		Factory(:operational_event, :subject_id => subject.id)
		Factory(:operational_event, :subject_id => subject.id)
		assert_difference('Subject.count',-1) {
		assert_difference('OperationalEvent.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy enrollments with subject" do
		subject = create_subject
		Factory(:enrollment, :subject_id => subject.id)
		Factory(:enrollment, :subject_id => subject.id)
		assert_difference('Subject.count',-1) {
		assert_difference('Enrollment.count',0) {
			subject.destroy
		} }
	end

	test "should have and belong to many analyses" do
		object = create_object
		assert_equal 0, object.analyses.length
		object.analyses << Factory(:analysis)
		assert_equal 1, object.reload.analyses.length
		object.analyses << Factory(:analysis)
		assert_equal 2, object.reload.analyses.length
	end

	test "should NOT destroy samples with subject" do
		subject = create_subject
		Factory(:sample, :subject_id => subject.id)
		Factory(:sample, :subject_id => subject.id)
		assert_difference('Subject.count',-1) {
		assert_difference('Sample.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy response_sets with subject" do
		subject = create_subject
		Factory(:response_set, :subject_id => subject.id)
		Factory(:response_set, :subject_id => subject.id)
		assert_difference('Subject.count',-1) {
		assert_difference('ResponseSet.count',0) {
			subject.destroy
		} }
	end

	test "should return nil ssn without identifier" do
		subject = create_subject
		assert_nil subject.ssn
	end

	test "should return ssn with identifier" do
		subject = Factory(:identifier, :subject => create_subject).subject
		assert_not_nil subject.ssn
	end

	test "should return nil full_name without pii" do
		subject = create_subject
		assert_nil subject.full_name
	end

	test "should return full_name with pii" do
		subject = Factory(:pii, :subject => create_subject).subject
		assert_not_nil subject.full_name
	end

	test "should return true response sets the same" do
		sets = create_survey_response_sets
		assert sets.first.subject.response_sets_the_same?
	end

	test "should return false response sets the same" do
		sets = create_survey_response_sets
		sets.last.responses.first.destroy
		assert !sets.first.subject.response_sets_the_same?
	end

	test "should raise error 1 response sets the same" do
		sets = create_survey_response_sets
		sets.last.destroy
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_sets_the_same?
		}
	end

	test "should raise error 3 response sets the same" do
		sets = create_survey_response_sets
		fill_out_survey(:survey => sets.first.survey,
			:subject => sets.first.subject)
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_sets_the_same?
		}
	end

	test "should return diffs on response set diffs" do
		sets = create_survey_response_sets
		sets.last.responses.first.destroy
		assert !sets.first.subject.response_set_diffs.blank?
	end

	test "should return empty diffs on response set diffs when the same" do
		sets = create_survey_response_sets
		assert sets.first.subject.response_set_diffs.blank?
	end

	test "should raise error 1 response set diffs" do
		sets = create_survey_response_sets
		sets.last.destroy
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_set_diffs
		}
	end

	test "should raise error 3 response set diffs" do
		sets = create_survey_response_sets
		fill_out_survey(:survey => sets.first.survey,
			:subject => sets.first.subject)
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_set_diffs
		}
	end

	test "should be ineligible for invitation without email" do
		subject = create_subject
		assert !subject.is_eligible_for_invitation?
	end

	test "should be eligible for invitation with email" do
		subject = create_subject(
			:pii_attributes => Factory.attributes_for(:pii))
		assert subject.is_eligible_for_invitation?
	end


#	test "should destroy patient on subject destroy" do
#		assert_difference( 'Patient.count', 1) {
#		assert_difference( 'Subject.count', 1) {
#			@subject = create_subject(
#				:patient_attributes => Factory.attributes_for(:patient))
#		} }
#		assert_difference( 'Patient.count', -1) {
#		assert_difference( 'Subject.count', -1) {
#			@subject.destroy
#		} }
#	end
#
#	test "should destroy dust_kit on subject destroy" do
#		assert_difference( 'DustKit.count', 1) {
#		assert_difference( 'Subject.count', 1) {
#			@subject = create_subject(
#				:dust_kit_attributes => Factory.attributes_for(:dust_kit))
#		} }
#		assert_difference( 'DustKit.count', -1) {
#		assert_difference( 'Subject.count', -1) {
#			@subject.destroy
#		} }
#	end
#
#	test "should destroy identifier on subject destroy" do
#		assert_difference( 'Identifier.count', 1) {
#		assert_difference( 'Subject.count', 1) {
#			@subject = create_subject(
#				:identifier_attributes => Factory.attributes_for(:identifier))
#		} }
#		assert_difference( 'Identifier.count', -1) {
#		assert_difference( 'Subject.count', -1) {
#			@subject.destroy
#		} }
#	end
#
#	test "should destroy pii on subject destroy" do
#		assert_difference( 'Pii.count', 1) {
#		assert_difference( 'Subject.count', 1) {
#			@subject = create_subject(
#				:pii_attributes => Factory.attributes_for(:pii))
#		} }
#		assert_difference( 'Pii.count', -1) {
#		assert_difference( 'Subject.count', -1) {
#			@subject.destroy
#		} }
#	end

	test "should require properly formated email address" do
		pending
	end

	test "should return race name for string" do
		subject = create_subject
		assert_equal subject.race.name, 
			"#{subject.race}"
	end

	test "should return subject_type description for string" do
		subject = create_subject
		assert_equal subject.subject_type.description,
			"#{subject.subject_type}"
	end

	test "should respond to search" do
		assert Subject.respond_to?(:search)
	end

	test "search should return Array" do
		subjects = Subject.search()
		assert subjects.is_a?(Array)
	end

	test "search should include subject" do
		subject = create_subject
		subjects = Subject.search()
		assert subjects.include?(subject)
	end

	test "search should include subject without pagination" do
		subject = create_subject
		subjects = Subject.search(:paginate => false)
		assert subjects.include?(subject)
	end

	test "search should include subject by subject_types" do
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		subjects = Subject.search(
			:types => [s1,s2].collect{|s|s.subject_type.description})
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "search should include subject by races" do
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		subjects = Subject.search(
			:races => [s1,s2].collect{|s|s.race.name})
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "search should include subject by hispanicity" do
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
pending
#		subjects = Subject.search(
#			:races => [s1,s2].collect{|s|s.race.name})
#		assert  subjects.include?(s1)
#		assert  subjects.include?(s2)
#		assert !subjects.include?(s3)
	end

	test "search should include subject by vital_statuses" do
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		subjects = Subject.search(
			:vital_statuses => [s1,s2].collect{|s|s.vital_status.code})
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end

#	test "search should include all subjects and ignore dust kits" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:subject_id => subject1.id)
#		subject2 = create_subject
#		subjects = Subject.search(:dust_kit => 'ignore')
#		assert subjects.include?(subject1)
#		assert subjects.include?(subject2)
#	end

#	test "search should include subjects with no dust kits" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:subject_id => subject1.id)
#		subject2 = create_subject
#		subjects = Subject.search(:dust_kit => 'none')
#		assert  subjects.include?(subject2)
#		assert !subjects.include?(subject1)
#	end

#	test "search should include subject with dust kit" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:subject_id => subject1.id)
#		subject2 = create_subject
#		subjects = Subject.search(:dust_kit => 'shipped')
#		assert  subjects.include?(subject1)
#		assert !subjects.include?(subject2)
#	end

#	test "search should include subject with dust kit delivered to subject" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:subject_id => subject1.id)
#		dust_kit.kit_package.update_attributes(:status => 'Delivered')
#		subject2 = create_subject
#		create_dust_kit(:subject_id => subject2.id)
#		subjects = Subject.search(:dust_kit => 'delivered')
#		assert  subjects.include?(subject1)
#		assert !subjects.include?(subject2)
#	end

#	test "search should include subject with dust kit returned to us" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:subject_id => subject1.id)
#		dust_kit.dust_package.update_attributes(:status => 'Transit')
#		subject2 = create_subject
#		create_dust_kit(:subject_id => subject2.id)
#		subjects = Subject.search(:dust_kit => 'returned')
#		assert  subjects.include?(subject1)
#		assert !subjects.include?(subject2)
#	end

#	test "search should include subject with dust kit received by us" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:subject_id => subject1.id)
#		dust_kit.dust_package.update_attributes(:status => 'Delivered')
#		subject2 = create_subject
#		create_dust_kit(:subject_id => subject2.id)
#		subjects = Subject.search(:dust_kit => 'received')
#		assert  subjects.include?(subject1)
#		assert !subjects.include?(subject2)
#	end

#	#	There was a problem doing finds which included joins
#	#	which included both named joins and sql fragment strings.
#	#	It should work, but didn't and required some manual
#	#	tweaking.
#	test "search should work with both dust_kit string and race symbol" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:subject_id => subject1.id)
#		subject2 = create_subject
#		subjects = Subject.search(:dust_kit => 'none', 
#			:races => [subject2.race.name] )
#		assert  subjects.include?(subject2)
#		assert !subjects.include?(subject1)
#	end


	test "search should include subject by multiple projects" do
		s1 = create_subject
		s2 = create_subject
		se1 = Factory(:project)
		se2 = Factory(:project)
		Factory(:enrollment, :project => se1, :subject => s1)
		Factory(:enrollment, :project => se2, :subject => s1)
		Factory(:enrollment, :project => se2, :subject => s2)
		subjects = Subject.search(:projects => {
			se1.id => {:eligible => [true,false]}, 
			se2.id => {:eligible => [true,false]}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by project indifferent completed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:completed_on => nil)
		Factory(:enrollment, :project => se, :subject => s2,
			:completed_on => Time.now)
		subjects = Subject.search(:projects => {se.id => {
			:completed => [true,false]
		}})
		assert subjects.include?(s1)
		assert subjects.include?(s2)
	end

	test "search should include subject by project not completed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:completed_on => nil)
		Factory(:enrollment, :project => se, :subject => s2,
			:completed_on => Time.now)
		subjects = Subject.search(:projects => {se.id => {
			:completed => false
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by project is completed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:completed_on => Time.now)
		Factory(:enrollment, :project => se, :subject => s2,
			:completed_on => nil)
		subjects = Subject.search(:projects => {se.id => {
			:completed => true
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end




	test "search should include subject by project indifferent closed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_closed => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_closed => true)
		subjects = Subject.search(:projects => {se.id => {
			:closed => [true,false]
		}})
		assert subjects.include?(s1)
		assert subjects.include?(s2)
	end

	test "search should include subject by project not closed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_closed => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_closed => true)
		subjects = Subject.search(:projects => {se.id => {
			:closed => false
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by project is closed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_closed => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_closed => false)
		subjects = Subject.search(:projects => {se.id => {
			:closed => true
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end


	test "search should include subject by project indifferent terminated" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:terminated_participation => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:terminated_participation => true)
		subjects = Subject.search(:projects => {se.id => {
			:terminated => [true,false]
		}})
		assert subjects.include?(s1)
		assert subjects.include?(s2)
	end

	test "search should include subject by project not terminated" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:terminated_participation => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:terminated_participation => true)
		subjects = Subject.search(:projects => {se.id => {
			:terminated => false
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by project is terminated" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:terminated_participation => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:terminated_participation => false)
		subjects = Subject.search(:projects => {se.id => {
			:terminated => true
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end


	test "search should include subject by project indifferent consented" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:consented => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:consented => true)
		subjects = Subject.search(:projects => {se.id => {
			:consented => [true,false]
		}})
		assert subjects.include?(s1)
		assert subjects.include?(s2)
	end

	test "search should include subject by project not consented" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:consented => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:consented => true)
		subjects = Subject.search(:projects => {se.id => {
			:consented => false
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by project is consented" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:consented => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:consented => false)
		subjects = Subject.search(:projects => {se.id => {
			:consented => true
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by project indifferent candidate" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_candidate => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_candidate => true)
		subjects = Subject.search(:projects => {se.id => {
			:candidate => [true,false]
		}})
		assert subjects.include?(s1)
		assert subjects.include?(s2)
	end

	test "search should include subject by project not candidate" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_candidate => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_candidate => true)
		subjects = Subject.search(:projects => {se.id => {
			:candidate => false
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by project is candidate" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_candidate => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_candidate => false)
		subjects = Subject.search(:projects => {se.id => {
			:candidate => true
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end


	test "search should include subject by project indifferent chosen" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_chosen => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_chosen => true)
		subjects = Subject.search(:projects => {se.id => {
			:chosen => [true,false]
		}})
		assert subjects.include?(s1)
		assert subjects.include?(s2)
	end

	test "search should include subject by project not chosen" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_chosen => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_chosen => true)
		subjects = Subject.search(:projects => {se.id => {
			:chosen => false
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by project is chosen" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_chosen => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_chosen => false)
		subjects = Subject.search(:projects => {se.id => {
			:chosen => true
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end


	test "search should include subject by project indifferent eligible" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_eligible => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_eligible => true)
		subjects = Subject.search(:projects => {se.id => {
			:eligible => [true,false]
		}})
		assert subjects.include?(s1)
		assert subjects.include?(s2)
	end

	test "search should include subject by project not eligible" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_eligible => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_eligible => true)
		subjects = Subject.search(:projects => {se.id => {
			:eligible => false
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by project is eligible" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_eligible => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_eligible => false)
		subjects = Subject.search(:projects => {se.id => {
			:eligible => true
		}})
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by having project" do
		subject1 = create_subject
		subject2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se,
			:subject => subject1)
		se2 = Factory(:project)
		Factory(:enrollment, :project => se2,
			:subject => subject2)
		subjects = Subject.search(:projects => {se.id => ''})
		assert  subjects.include?(subject1)
		assert !subjects.include?(subject2)
	end

	test "search should NOT order by other stuff with dir" do
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		subjects = Subject.search(:order => 'whatever', :dir => 'asc')
		assert_equal [s1,s2,s3], subjects
	end

	test "search should NOT order by other stuff" do
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		subjects = Subject.search(:order => 'whatever')
		assert_equal [s1,s2,s3], subjects
	end

	test "search should order by outcome_date asc by default" do
		pending
	end

	test "search should order by outcome_date desc" do
		pending
	end

	test "search should order by outcome asc by default" do
		pending
	end

	test "search should order by outcome desc" do
		pending
	end

	test "search should order by priority asc by default" do
		se = Factory(:project)
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		Factory(:enrollment, :project => se, :subject => s1,
			:recruitment_priority => 9)
		Factory(:enrollment, :project => se, :subject => s2,
			:recruitment_priority => 3)
		Factory(:enrollment, :project => se, :subject => s3,
			:recruitment_priority => 6)
		subjects = se.subjects.search(:order => 'priority')
#		subjects = Subject.search(:order => 'priority',
#			:projects => { se.id => {} })
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by priority desc" do
		se = Factory(:project)
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		Factory(:enrollment, :project => se, :subject => s1,
			:recruitment_priority => 9)
		Factory(:enrollment, :project => se, :subject => s2,
			:recruitment_priority => 3)
		Factory(:enrollment, :project => se, :subject => s3,
			:recruitment_priority => 6)
		subjects = se.subjects.search(:order => 'priority',:dir => 'desc')
#		subjects = Subject.search(:order => 'priority',:dir => 'desc',
#			:projects => { se.id => {} })
		assert_equal [s1,s3,s2], subjects
	end

	test "search should order by childid asc by default" do
		s1 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :childid => '9'))
		s2 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :childid => '3' ))
		s3 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :childid => '6' ))
		subjects = Subject.search(:order => 'childid')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by childid asc" do
		s1 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :childid => '9'))
		s2 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :childid => '3' ))
		s3 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :childid => '6' ))
		subjects = Subject.search(:order => 'childid', :dir => 'asc')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by childid desc" do
		s1 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :childid => '9'))
		s2 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :childid => '3' ))
		s3 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :childid => '6' ))
		subjects = Subject.search(:order => 'childid', :dir => 'desc')
		assert_equal [s1,s3,s2], subjects
	end

	test "search should order by studyid asc" do
		s1 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :patid => '9' ))
		s2 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :patid => '3' ))
		s3 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :patid => '6' ))
		subjects = Subject.search(:order => 'studyid')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by studyid desc" do
		s1 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :patid => '9' ))
		s2 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :patid => '3' ))
		s3 = create_subject(:identifier_attributes => Factory.attributes_for(
			:identifier, :patid => '6' ))
		subjects = Subject.search(:order => 'studyid', :dir => 'desc')
		assert_equal [s1,s3,s2], subjects
	end

	test "search should order by last_name asc" do
		s1 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:last_name => '9' ))
		s2 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:last_name => '3' ))
		s3 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:last_name => '6' ))
		subjects = Subject.search(:order => 'last_name')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by last_name desc" do
		s1 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:last_name => '9' ))
		s2 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:last_name => '3' ))
		s3 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:last_name => '6' ))
		subjects = Subject.search(:order => 'last_name', :dir => 'desc')
		assert_equal [s1,s3,s2], subjects
	end

	test "search should order by first_name asc" do
		s1 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:first_name => '9' ))
		s2 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:first_name => '3' ))
		s3 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:first_name => '6' ))
		subjects = Subject.search(:order => 'first_name')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by first_name desc" do
		s1 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:first_name => '9' ))
		s2 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:first_name => '3' ))
		s3 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:first_name => '6' ))
		subjects = Subject.search(:order => 'first_name', :dir => 'desc')
		assert_equal [s1,s3,s2], subjects
	end

	test "search should order by dob asc" do
		s1 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:dob => Time.parse('12/31/2005') ))
		s2 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:dob => Time.parse('12/31/2001') ))
		s3 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:dob => Time.parse('12/31/2003') ))
		subjects = Subject.search(:order => 'dob')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by dob desc" do
		s1 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:dob => Time.parse('12/31/2005') ))
		s2 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:dob => Time.parse('12/31/2001') ))
		s3 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:dob => Time.parse('12/31/2003') ))
		subjects = Subject.search(:order => 'dob', :dir => 'desc')
		assert_equal [s1,s3,s2], subjects
	end

#	#	There was a problem doing finds which included joins
#	#	which included both sql join fragment strings and an order.
#	test "search should work with both dust_kit string and order" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:subject_id => subject1.id)
#		subject2 = create_subject
#		subjects = Subject.search(:dust_kit => 'none', 
#			:order => 'childid')
#		assert  subjects.include?(subject2)
#		assert !subjects.include?(subject1)
#	end

	test "search should include subject by q first_name" do
		s1 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:first_name => 'Michael'))
		s2 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:first_name => 'Bob'))
		subjects = Subject.search(:q => 'mi ch ha')
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by q last_name" do
		s1 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:last_name => 'Michael'))
		s2 = create_subject(:pii_attributes => Factory.attributes_for(:pii, 
			:last_name => 'Bob'))
		subjects = Subject.search(:q => 'cha ael')
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by q childid" do
		s1 = create_subject(:identifier_attributes => Factory.attributes_for(:identifier,
			:childid => 999999))
		s2 = create_subject(:identifier_attributes => Factory.attributes_for(:identifier))
		subjects = Subject.search(:q => s1.identifier.childid)
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by q patid" do
		s1 = create_subject(:identifier_attributes => Factory.attributes_for(:identifier,
			:patid => 999999))
		s2 = create_subject(:identifier_attributes => Factory.attributes_for(:identifier))
		subjects = Subject.search(:q => s1.identifier.patid)
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

#	test "should return dust_kit_status of None" do
#		subject = create_subject
#		assert_equal 'None', subject.dust_kit_status
#	end

#	test "should return dust_kit_status of New" do
#		subject = create_subject
#		dust_kit = create_dust_kit(:subject_id => subject.id)
#		assert_equal 'New', subject.dust_kit_status
#	end

protected

	def create_survey_response_sets
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey,
			:subject => rs1.subject)
		[rs1.reload,rs2.reload]
	end

	def create_subject(options = {})
		record = Factory.build(:subject,options)
		record.save
		record
	end
	alias_method :create_object, :create_subject

#	def create_dust_kit(options = {})
#		Factory(:dust_kit, {
#			:kit_package_attributes  => Factory.attributes_for(:package),
#			:dust_package_attributes => Factory.attributes_for(:package) 
#		}.merge(options))
#	end

end
