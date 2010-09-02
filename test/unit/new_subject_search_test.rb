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
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		subjects = SubjectSearch.new(
			:types => [s1,s2].collect{|s|s.subject_type.description}).subjects
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end
	
	test "should include subject by races" do
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		subjects = SubjectSearch.new(
			:races => [s1,s2].collect{|s|s.race.name}).subjects
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should include subject by hispanicity" do
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

	test "should include subject by vital_statuses" do
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		subjects = SubjectSearch.new(
			:vital_statuses => [s1,s2].collect{|s|s.vital_status.code}).subjects
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end
	
	test "should include subject by multiple projects" do
		s1 = create_subject
		s2 = create_subject
		se1 = Factory(:project)
		se2 = Factory(:project)
		Factory(:enrollment, :project => se1, :subject => s1)
		Factory(:enrollment, :project => se2, :subject => s1)
		Factory(:enrollment, :project => se2, :subject => s2)
		pending
#		subjects = Subject.search(:projects => {
#			se1.id => {:eligible => [true,false]}, 
#			se2.id => {:eligible => [true,false]}})
#		assert  subjects.include?(s1)
#		assert !subjects.include?(s2)
	end

	test "should include subject by project indifferent completed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:completed_on => nil)
		Factory(:enrollment, :project => se, :subject => s2,
			:completed_on => Time.now)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:completed => [true,false]
#		}})
#		assert subjects.include?(s1)
#		assert subjects.include?(s2)
	end

	test "should include subject by project not completed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:completed_on => nil)
		Factory(:enrollment, :project => se, :subject => s2,
			:completed_on => Time.now)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:completed => false
#		}})
#		assert  subjects.include?(s1)
#		assert !subjects.include?(s2)
	end

	test "should include subject by project is completed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:completed_on => Time.now)
		Factory(:enrollment, :project => se, :subject => s2,
			:completed_on => nil)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:completed => true
#		}})
#		assert  subjects.include?(s1)
#		assert !subjects.include?(s2)
	end

	test "should include subject by project indifferent closed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_closed => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_closed => true)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:closed => [true,false]
#		}})
#		assert subjects.include?(s1)
#		assert subjects.include?(s2)
	end

	test "should include subject by project not closed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_closed => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_closed => true)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:closed => false
#		}})
#		assert  subjects.include?(s1)
#		assert !subjects.include?(s2)
	end

	test "should include subject by project is closed" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_closed => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_closed => false)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:closed => true
#		}})
#		assert  subjects.include?(s1)
#		assert !subjects.include?(s2)
	end


	test "should include subject by project indifferent terminated" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:terminated_participation => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:terminated_participation => true,
			:terminated_reason => 'unknown')
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:terminated => [true,false]
#		}})
#		assert subjects.include?(s1)
#		assert subjects.include?(s2)
	end

	test "should include subject by project not terminated" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:terminated_participation => false)
		Factory(:enrollment, :project => se, :subject => s2,
			:terminated_participation => true,
			:terminated_reason => 'unknown')
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:terminated => false
#		}})
#		assert  subjects.include?(s1)
#		assert !subjects.include?(s2)
	end

	test "should include subject by project is terminated" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:terminated_participation => true,
			:terminated_reason => 'unknown')
		Factory(:enrollment, :project => se, :subject => s2,
			:terminated_participation => false)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:terminated => true
#		}})
#		assert  subjects.include?(s1)
#		assert !subjects.include?(s2)
	end

	test "should include subject by project indifferent consented" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:consented => false,
			:refusal_reason_id => RefusalReason.first.id)
		Factory(:enrollment, :project => se, :subject => s2,
			:consented => true)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:consented => [true,false]
#		}})
#		assert subjects.include?(s1)
#		assert subjects.include?(s2)
	end

	test "should include subject by project not consented" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:consented => false,
			:refusal_reason_id => RefusalReason.first.id)
		Factory(:enrollment, :project => se, :subject => s2,
			:consented => true)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:consented => false
#		}})
#		assert  subjects.include?(s1)
#		assert !subjects.include?(s2)
	end

	test "should include subject by project is consented" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:consented => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:consented => false,
			:refusal_reason_id => RefusalReason.first.id)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:consented => true
#		}})
#		assert  subjects.include?(s1)
#		assert !subjects.include?(s2)
	end

	test "should include subject by project indifferent candidate" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_candidate => false,
			:ineligible_reason_id => IneligibleReason.first.id)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_candidate => true)
		pending
#		subjects = Subject.search(:projects => {se.id => {
#			:candidate => [true,false]
#		}})
#		assert subjects.include?(s1)
#		assert subjects.include?(s2)
	end

	test "should include subject by project not candidate" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_candidate => false,
			:ineligible_reason_id => IneligibleReason.first.id)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_candidate => true)
		pending
#			subjects = Subject.search(:projects => {se.id => {
#				:candidate => false
#			}})
#			assert  subjects.include?(s1)
#			assert !subjects.include?(s2)
	end

	test "should include subject by project is candidate" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_candidate => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_candidate => false,
			:ineligible_reason_id => IneligibleReason.first.id)
		pending
#			subjects = Subject.search(:projects => {se.id => {
#				:candidate => true
#			}})
#			assert  subjects.include?(s1)
#			assert !subjects.include?(s2)
	end

	test "should include subject by project indifferent chosen" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_chosen => false,
			:reason_not_chosen => 'unknown')
		Factory(:enrollment, :project => se, :subject => s2,
			:is_chosen => true)
		pending
#			subjects = Subject.search(:projects => {se.id => {
#				:chosen => [true,false]
#			}})
#			assert subjects.include?(s1)
#			assert subjects.include?(s2)
	end

	test "should include subject by project not chosen" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_chosen => false,
			:reason_not_chosen => 'unknown')
		Factory(:enrollment, :project => se, :subject => s2,
			:is_chosen => true)
		pending
#			subjects = Subject.search(:projects => {se.id => {
#				:chosen => false
#			}})
#			assert  subjects.include?(s1)
#			assert !subjects.include?(s2)
	end

	test "should include subject by project is chosen" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_chosen => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_chosen => false,
			:reason_not_chosen => 'unknown')
		pending
#			subjects = Subject.search(:projects => {se.id => {
#				:chosen => true
#			}})
#			assert  subjects.include?(s1)
#			assert !subjects.include?(s2)
	end


	test "should include subject by project indifferent eligible" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_eligible => false,
			:ineligible_reason_id => IneligibleReason.first.id)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_eligible => true)
		pending
#			subjects = Subject.search(:projects => {se.id => {
#				:eligible => [true,false]
#			}})
#			assert subjects.include?(s1)
#			assert subjects.include?(s2)
	end

	test "should include subject by project not eligible" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_eligible => false,
			:ineligible_reason_id => IneligibleReason.first.id)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_eligible => true)
		pending
#			subjects = Subject.search(:projects => {se.id => {
#				:eligible => false
#			}})
#			assert  subjects.include?(s1)
#			assert !subjects.include?(s2)
	end

	test "should include subject by project is eligible" do
		s1 = create_subject
		s2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se, :subject => s1,
			:is_eligible => true)
		Factory(:enrollment, :project => se, :subject => s2,
			:is_eligible => false,
			:ineligible_reason_id => IneligibleReason.first.id)
		pending
#			subjects = Subject.search(:projects => {se.id => {
#				:eligible => true
#			}})
#			assert  subjects.include?(s1)
#			assert !subjects.include?(s2)
	end

	test "should include subject by having project" do
		subject1 = create_subject
		subject2 = create_subject
		se = Factory(:project)
		Factory(:enrollment, :project => se,
			:subject => subject1)
		se2 = Factory(:project)
		Factory(:enrollment, :project => se2,
			:subject => subject2)
		pending
#			subjects = Subject.search(:projects => {se.id => ''})
#			assert  subjects.include?(subject1)
#			assert !subjects.include?(subject2)
	end

	test "should NOT order by bogus column with dir" do
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		subjects = SubjectSearch.new(
			:order => 'whatever', :dir => 'asc').subjects
		assert_equal [s1,s2,s3], subjects
	end

	test "should NOT order by bogus column" do
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
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

	test "should order by studyid asc" do
		s1,s2,s3 = three_subjects_with_patid
		subjects = SubjectSearch.new(
			:order => 'studyid').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by studyid desc" do
		s1,s2,s3 = three_subjects_with_patid
		subjects = SubjectSearch.new(
			:order => 'studyid', :dir => 'desc').subjects
		assert_equal [s1,s3,s2], subjects
	end

	test "should order by last_name asc" do
		s1,s2,s3 = three_subjects_with_last_name
		subjects = SubjectSearch.new(
			:order => 'last_name').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by last_name desc" do
		s1,s2,s3 = three_subjects_with_last_name
		subjects = SubjectSearch.new(
			:order => 'last_name', :dir => 'desc').subjects
		assert_equal [s1,s3,s2], subjects
	end

	test "should order by first_name asc" do
		s1,s2,s3 = three_subjects_with_first_name
		subjects = SubjectSearch.new(
			:order => 'first_name').subjects
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by first_name desc" do
		s1,s2,s3 = three_subjects_with_first_name
		subjects = SubjectSearch.new(
			:order => 'first_name', :dir => 'desc').subjects
		assert_equal [s1,s3,s2], subjects
	end

	test "should order by dob asc" do
		s1,s2,s3 = three_subjects_with_dob
		subjects = SubjectSearch.new(
			:order => 'dob').subjects
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
		s1 = create_subject
		s1.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Complete').id)
		s2 = create_subject
		s2.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Pending').id)
		s3 = create_subject
		subjects = SubjectSearch.new(
			:sample_outcome => 'Complete').subjects
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should include subjects with incomplete sample" do
		s1 = create_subject
		s1.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Complete').id)
		s2 = create_subject
		s2.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Pending').id)
		s3 = create_subject
		subjects = SubjectSearch.new(
			:sample_outcome => 'Incomplete').subjects
		assert !subjects.include?(s1)
		assert  subjects.include?(s2)
		assert  subjects.include?(s3)
	end

	test "should include subjects with complete interview" do
		s1 = create_subject
		s1.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Complete').id)
		s2 = create_subject
		s2.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Incomplete').id)
		s3 = create_subject
		subjects = SubjectSearch.new(
			:interview_outcome => 'Complete').subjects
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should include subjects with incomplete interview" do
		s1 = create_subject
		s1.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Complete').id)
		s2 = create_subject
		s2.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Incomplete').id)
		s3 = create_subject
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
