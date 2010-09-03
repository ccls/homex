require File.dirname(__FILE__) + '/../test_helper'

class NewSubjectSearchTest < ActiveSupport::TestCase

	test "should return SubjectSearch" do
		assert SubjectSearch().is_a?(SubjectSearch)
	end
	
	test "should return Array" do
		subjects = SubjectSearch.new().subjects
		assert subjects.is_a?(Array)
	end
	
	test "should include subject" do
		subject = create_subject
		subjects = SubjectSearch.new().subjects
		assert subjects.include?(subject)
	end
	
	test "should include subject without pagination" do
		subject = create_subject
		subjects = SubjectSearch(:paginate => false).subjects
		assert subjects.include?(subject)
	end
	
	test "should include subject by subject_types" do
		s1,s2,s3 = create_subjects(3)
		subjects = SubjectSearch.new(
			:types => [s1,s2].collect{|s|s.subject_type.description}
		).subjects
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end
	
	test "should include subject by races" do
		s1,s2,s3 = create_subjects(3)
		subjects = SubjectSearch.new(
			:races => [s1,s2].collect{|s|s.race.name}).subjects
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should include subject by hispanicity" do
		s1,s2,s3 = create_subjects(3)
pending
#		subjects = Subject.search(
#			:races => [s1,s2].collect{|s|s.race.name})
#		assert  subjects.include?(s1)
#		assert  subjects.include?(s2)
#		assert !subjects.include?(s3)
	end

	test "should include subject by vital_statuses" do
		s1,s2,s3 = create_subjects(3)
		subjects = SubjectSearch.new(
			:vital_statuses => [s1,s2].collect{|s|s.vital_status.code}
		).subjects
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end
	
	test "should include subject by having project" do
		e1 = Factory(:enrollment)
		e2 = Factory(:enrollment)
		subjects = SubjectSearch.new(
			:projects => {e1.project.id => ''}).subjects
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by multiple projects" do
		e1 = Factory(:enrollment)
		e2 = Factory(:enrollment,:subject => e1.subject)
		e3 = Factory(:enrollment,:project => e2.project)
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => '',
			e2.project.id => ''
		}).subjects
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e3.subject)
	end


	test "should include subject by project indifferent completed" do
		e1 = Factory(:enrollment, :completed_on => nil,
			:is_complete => false)
		e2 = Factory(:enrollment, :completed_on => Time.now,
			:is_complete => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :completed => [true,false] }
		}).subjects
		assert subjects.include?(e1.subject)
		assert subjects.include?(e2.subject)
	end

	test "should include subject by project not completed" do
		e1 = Factory(:enrollment, :completed_on => nil,
			:is_complete => false)
		e2 = Factory(:enrollment, :completed_on => Time.now,
			:is_complete => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :completed => false }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is completed" do
		e1 = Factory(:enrollment, :completed_on => nil,
			:is_complete => false)
		e2 = Factory(:enrollment, :completed_on => Time.now,
			:is_complete => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :completed => true }
		}).subjects
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end


	test "should include subject by project indifferent closed" do
		e1 = Factory(:enrollment, :is_closed => false)
		e2 = Factory(:enrollment, :is_closed => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :closed => [true,false] }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not closed" do
		e1 = Factory(:enrollment, :is_closed => false)
		e2 = Factory(:enrollment, :is_closed => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :closed => false }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is closed" do
		e1 = Factory(:enrollment, :is_closed => false)
		e2 = Factory(:enrollment, :is_closed => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :closed => true }
		}).subjects
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end


	test "should include subject by project indifferent terminated" do
		e1 = Factory(:enrollment, :terminated_participation => false)
		e2 = Factory(:enrollment, :terminated_participation => true,
			:terminated_reason => 'unknown',
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :terminated => [true,false] }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not terminated" do
		e1 = Factory(:enrollment, :terminated_participation => false)
		e2 = Factory(:enrollment, :terminated_participation => true,
			:terminated_reason => 'unknown',
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :terminated => false }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is terminated" do
		e1 = Factory(:enrollment, :terminated_participation => false)
		e2 = Factory(:enrollment, :terminated_participation => true,
			:terminated_reason => 'unknown',
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :terminated => true }
		}).subjects
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end


	test "should include subject by project indifferent consented" do
		e1 = Factory(:enrollment, :consented => false,
			:refusal_reason_id => RefusalReason.first.id)
		e2 = Factory(:enrollment, :consented => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :consented => [true,false] }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not consented" do
		e1 = Factory(:enrollment, :consented => false,
			:refusal_reason_id => RefusalReason.first.id)
		e2 = Factory(:enrollment, :consented => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :consented => false }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is consented" do
		e1 = Factory(:enrollment, :consented => false,
			:refusal_reason_id => RefusalReason.first.id)
		e2 = Factory(:enrollment, :consented => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :consented => true }
		}).subjects
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end


	test "should include subject by project indifferent candidate" do
		e1 = Factory(:enrollment, :is_candidate => false)
		e2 = Factory(:enrollment, :is_candidate => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :candidate => [true,false] }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not candidate" do
		e1 = Factory(:enrollment, :is_candidate => false)
		e2 = Factory(:enrollment, :is_candidate => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :candidate => false }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is candidate" do
		e1 = Factory(:enrollment, :is_candidate => false)
		e2 = Factory(:enrollment, :is_candidate => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :candidate => true }
		}).subjects
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end


	test "should include subject by project indifferent chosen" do
		e1 = Factory(:enrollment, :is_chosen => false,
			:reason_not_chosen => 'unknown')
		e2 = Factory(:enrollment, :is_chosen => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :chosen => [true,false] }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not chosen" do
		e1 = Factory(:enrollment, :is_chosen => false,
			:reason_not_chosen => 'unknown')
		e2 = Factory(:enrollment, :is_chosen => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :chosen => false }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is chosen" do
		e1 = Factory(:enrollment, :is_chosen => false,
			:reason_not_chosen => 'unknown')
		e2 = Factory(:enrollment, :is_chosen => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :chosen => true }
		}).subjects
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end


	test "should include subject by project indifferent eligible" do
		e1 = Factory(:enrollment, :is_eligible => false,
			:ineligible_reason_id => IneligibleReason.first.id)
		e2 = Factory(:enrollment, :is_eligible => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :eligible => [true,false] }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not eligible" do
		e1 = Factory(:enrollment, :is_eligible => false,
			:ineligible_reason_id => IneligibleReason.first.id)
		e2 = Factory(:enrollment, :is_eligible => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :eligible => false }
		}).subjects
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is eligible" do
		e1 = Factory(:enrollment, :is_eligible => false,
			:ineligible_reason_id => IneligibleReason.first.id)
		e2 = Factory(:enrollment, :is_eligible => true,
			:project => e1.project )
		subjects = SubjectSearch.new(:projects => {
			e1.project.id => { :eligible => true }
		}).subjects
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should NOT order by bogus column with dir" do
		s1,s2,s3 = create_subjects(3)
		subjects = SubjectSearch.new(
			:order => 'whatever', :dir => 'asc').subjects
		assert_equal [s1,s2,s3], subjects
	end

	test "should NOT order by bogus column" do
		s1,s2,s3 = create_subjects(3)
		subjects = SubjectSearch.new(:order => 'whatever').subjects
		assert_equal [s1,s2,s3], subjects
	end

	test "should order by priority asc by default" do
		se,s1,s2,s3 = three_subjects_with_recruitment_priority
		pending
#			subjects = se.subjects.search(:order => 'priority')
#	#		subjects = Subject.search(:order => 'priority',
#	#			:projects => { se.id => {} })
#			assert_equal [s2,s3,s1], subjects
	end

	test "should order by priority desc" do
		se,s1,s2,s3 = three_subjects_with_recruitment_priority
		pending
#			subjects = se.subjects.search(:order => 'priority',:dir => 'desc')
#	#		subjects = Subject.search(:order => 'priority',:dir => 'desc',
#	#			:projects => { se.id => {} })
#			assert_equal [s1,s3,s2], subjects
	end

	test "should order by id asc by default" do
		s1,s2,s3 = three_subjects_with_childid
		subjects = SubjectSearch.new(
			:order => 'id').subjects
		assert_equal [s1,s2,s3], subjects
	end

	test "should order by id asc" do
		s1,s2,s3 = three_subjects_with_childid
		subjects = SubjectSearch.new(
			:order => 'id', :dir => 'asc').subjects
		assert_equal [s1,s2,s3], subjects
	end

	test "should order by id desc" do
		s1,s2,s3 = three_subjects_with_childid
		subjects = SubjectSearch.new(
			:order => 'id', :dir => 'desc').subjects
		assert_equal [s3,s2,s1], subjects
	end

	test "should order by childid asc by default" do
		s1,s2,s3 = three_subjects_with_childid
		subjects = SubjectSearch.new(
			:order => 'childid').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by childid asc" do
		s1,s2,s3 = three_subjects_with_childid
		subjects = SubjectSearch.new(
			:order => 'childid', :dir => 'asc').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by childid desc" do
		s1,s2,s3 = three_subjects_with_childid
		subjects = SubjectSearch.new(
			:order => 'childid', :dir => 'desc').subjects
		assert_equal [s1,s3,s2], subjects
	end

	test "should order by studyid asc by default" do
		s1,s2,s3 = three_subjects_with_patid
		subjects = SubjectSearch.new(
			:order => 'studyid').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by studyid asc" do
		s1,s2,s3 = three_subjects_with_patid
		subjects = SubjectSearch.new(
			:order => 'studyid', :dir => 'asc').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by studyid desc" do
		s1,s2,s3 = three_subjects_with_patid
		subjects = SubjectSearch.new(
			:order => 'studyid', :dir => 'desc').subjects
		assert_equal [s1,s3,s2], subjects
	end

	test "should order by last_name asc by default" do
		s1,s2,s3 = three_subjects_with_last_name
		subjects = SubjectSearch.new(
			:order => 'last_name').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by last_name asc" do
		s1,s2,s3 = three_subjects_with_last_name
		subjects = SubjectSearch.new(
			:order => 'last_name', :dir => 'asc').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by last_name desc" do
		s1,s2,s3 = three_subjects_with_last_name
		subjects = SubjectSearch.new(
			:order => 'last_name', :dir => 'desc').subjects
		assert_equal [s1,s3,s2], subjects
	end

	test "should order by first_name asc by default" do
		s1,s2,s3 = three_subjects_with_first_name
		subjects = SubjectSearch.new(
			:order => 'first_name').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by first_name asc" do
		s1,s2,s3 = three_subjects_with_first_name
		subjects = SubjectSearch.new(
			:order => 'first_name', :dir => 'asc').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by first_name desc" do
		s1,s2,s3 = three_subjects_with_first_name
		subjects = SubjectSearch.new(
			:order => 'first_name', :dir => 'desc').subjects
		assert_equal [s1,s3,s2], subjects
	end

	test "should order by dob asc by default" do
		s1,s2,s3 = three_subjects_with_dob
		subjects = SubjectSearch.new(
			:order => 'dob').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by dob asc" do
		s1,s2,s3 = three_subjects_with_dob
		subjects = SubjectSearch.new(
			:order => 'dob', :dir => 'asc').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by dob desc" do
		s1,s2,s3 = three_subjects_with_dob
		subjects = SubjectSearch.new(
			:order => 'dob', :dir => 'desc').subjects
		assert_equal [s1,s3,s2], subjects
	end

	test "should include subject by q first_name" do
		s1 = create_subject_with_first_name('Michael')
		s2 = create_subject_with_first_name('Bob')
		subjects = SubjectSearch.new(
			:q => 'mi ch ha').subjects
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "should include subject by q last_name" do
		s1 = create_subject_with_last_name('Michael')
		s2 = create_subject_with_last_name('Bob')
		subjects = SubjectSearch.new(
			:q => 'cha ael').subjects
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "should include subject by q childid" do
		s1 = create_subject_with_childid(999999)
		s2 = create_subject_with_childid('1')
		subjects = SubjectSearch.new(
			:q => s1.identifier.childid).subjects
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "should include subject by q patid" do
		s1 = create_subject_with_patid(999999)
		s2 = create_subject_with_patid('1')
		subjects = SubjectSearch.new(
			:q => s1.identifier.patid).subjects
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "should include subjects with complete sample" do
		s1,s2,s3 = create_subjects(3)
		s1.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Complete').id)
		s2.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Pending').id)
		subjects = SubjectSearch.new(
			:sample_outcome => 'Complete').subjects
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should include subjects with incomplete sample" do
		s1,s2,s3 = create_subjects(3)
		s1.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Complete').id)
		s2.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Pending').id)
		subjects = SubjectSearch.new(
			:sample_outcome => 'Incomplete').subjects
		assert !subjects.include?(s1)
		assert  subjects.include?(s2)
		assert  subjects.include?(s3)
	end

	test "should include subjects with complete interview" do
		s1,s2,s3 = create_subjects(3)
		s1.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Complete').id)
		s2.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Incomplete').id)
		subjects = SubjectSearch.new(
			:interview_outcome => 'Complete').subjects
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should include subjects with incomplete interview" do
		s1,s2,s3 = create_subjects(3)
		s1.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Complete').id)
		s2.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Incomplete').id)
		subjects = SubjectSearch.new(
			:interview_outcome => 'Incomplete').subjects
		assert !subjects.include?(s1)
		assert  subjects.include?(s2)
		assert  subjects.include?(s3)
	end

protected

	def create_survey_response_sets
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey,
			:subject => rs1.subject)
		[rs1.reload,rs2.reload]
	end

end
