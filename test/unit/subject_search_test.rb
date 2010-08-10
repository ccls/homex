require File.dirname(__FILE__) + '/../test_helper'

class SubjectSearchTest < ActiveSupport::TestCase

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
		s1 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :childid => '9'))
		s2 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :childid => '3' ))
		s3 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :childid => '6' ))
		subjects = Subject.search(:order => 'childid')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by childid asc" do
		s1 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :childid => '9'))
		s2 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :childid => '3' ))
		s3 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :childid => '6' ))
		subjects = Subject.search(:order => 'childid', :dir => 'asc')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by childid desc" do
		s1 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :childid => '9'))
		s2 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :childid => '3' ))
		s3 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :childid => '6' ))
		subjects = Subject.search(:order => 'childid', :dir => 'desc')
		assert_equal [s1,s3,s2], subjects
	end

	test "search should order by studyid asc" do
		s1 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :patid => '9' ))
		s2 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :patid => '3' ))
		s3 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :patid => '6' ))
		subjects = Subject.search(:order => 'studyid')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by studyid desc" do
		s1 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :patid => '9' ))
		s2 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :patid => '3' ))
		s3 = create_subject(
			:identifier_attributes => Factory.attributes_for(
				:identifier, :patid => '6' ))
		subjects = Subject.search(:order => 'studyid', :dir => 'desc')
		assert_equal [s1,s3,s2], subjects
	end

	test "search should order by last_name asc" do
		s1 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => '9' ))
		s2 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => '3' ))
		s3 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => '6' ))
		subjects = Subject.search(:order => 'last_name')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by last_name desc" do
		s1 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => '9' ))
		s2 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => '3' ))
		s3 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => '6' ))
		subjects = Subject.search(:order => 'last_name', :dir => 'desc')
		assert_equal [s1,s3,s2], subjects
	end

	test "search should order by first_name asc" do
		s1 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => '9' ))
		s2 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => '3' ))
		s3 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => '6' ))
		subjects = Subject.search(:order => 'first_name')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by first_name desc" do
		s1 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => '9' ))
		s2 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => '3' ))
		s3 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => '6' ))
		subjects = Subject.search(:order => 'first_name', :dir => 'desc')
		assert_equal [s1,s3,s2], subjects
	end

	test "search should order by dob asc" do
		s1 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:dob => Time.parse('12/31/2005') ))
		s2 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:dob => Time.parse('12/31/2001') ))
		s3 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:dob => Time.parse('12/31/2003') ))
		subjects = Subject.search(:order => 'dob')
		assert_equal [s2,s3,s1], subjects
	end

	test "search should order by dob desc" do
		s1 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:dob => Time.parse('12/31/2005') ))
		s2 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:dob => Time.parse('12/31/2001') ))
		s3 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
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
		s1 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => 'Michael'))
		s2 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => 'Bob'))
		subjects = Subject.search(:q => 'mi ch ha')
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by q last_name" do
		s1 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => 'Michael'))
		s2 = create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => 'Bob'))
		subjects = Subject.search(:q => 'cha ael')
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by q childid" do
		s1 = create_subject(
			:identifier_attributes => Factory.attributes_for(:identifier,
				:childid => 999999))
		s2 = create_subject(
			:identifier_attributes => Factory.attributes_for(:identifier))
		subjects = Subject.search(:q => s1.identifier.childid)
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "search should include subject by q patid" do
		s1 = create_subject(
			:identifier_attributes => Factory.attributes_for(:identifier,
				:patid => 999999))
		s2 = create_subject(
			:identifier_attributes => Factory.attributes_for(:identifier))
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





	test "should search for subjects with complete sample" do
		s1 = create_subject
		s1.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Complete').id)
		s2 = create_subject
		s2.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Pending').id)
		s3 = create_subject
		subjects = Subject.search(:sample_outcome => 'Complete')
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should search for subjects with incomplete sample" do
		s1 = create_subject
		s1.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Complete').id)
		s2 = create_subject
		s2.create_homex_outcome(
			:sample_outcome_id => 
				SampleOutcome.find_by_code('Pending').id)
		s3 = create_subject
		subjects = Subject.search(:sample_outcome => 'Incomplete')
		assert !subjects.include?(s1)
		assert  subjects.include?(s2)
		assert  subjects.include?(s3)
	end

	test "should search for subjects with complete interview" do
		s1 = create_subject
		s1.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Complete').id)
		s2 = create_subject
		s2.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Incomplete').id)
		s3 = create_subject
		subjects = Subject.search(:interview_outcome => 'Complete')
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should search for subjects with incomplete interview" do
		s1 = create_subject
		s1.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Complete').id)
		s2 = create_subject
		s2.create_homex_outcome(
			:interview_outcome_id => 
				InterviewOutcome.find_by_code('Incomplete').id)
		s3 = create_subject
		subjects = Subject.search(:interview_outcome => 'Incomplete')
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

	def create_subject(options = {})
		record = Factory.build(:subject,options)
		record.save
		record
	end
	alias_method :create_object, :create_subject

end
