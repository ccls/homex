namespace :app do

	desc "Load some fixtures to database for application"
	task :setup => :environment do
		fixtures = []
		fixtures.push('address_types')
		fixtures.push('data_sources')
		fixtures.push('ineligible_reasons')
		fixtures.push('interview_methods')
		fixtures.push('interview_outcomes')
		fixtures.push('interview_types')
		fixtures.push('languages')
		fixtures.push('pages')
		fixtures.push('races')
		fixtures.push('roles')
		fixtures.push('projects')
		fixtures.push('refusal_reasons')
#		fixtures.push('sample_subtypes')
		fixtures.push('sample_outcomes')
		fixtures.push('sample_types')
		fixtures.push('subject_types')
		fixtures.push('units')
		fixtures.push('vital_statuses')
		ENV['FIXTURES'] = fixtures.join(',')
		puts "Loading fixtures for #{ENV['FIXTURES']}"
		Rake::Task["db:fixtures:load"].invoke
		Rake::Task["app:add_users"].invoke
		ENV['uid'] = '859908'
		Rake::Task["app:deputize"].invoke
		ENV['uid'] = '228181'
		Rake::Task["app:deputize"].reenable	#	<- this is stupid!
		Rake::Task["app:deputize"].invoke
	end

	desc "DEV: Add some CCLS subjects"
	task :add_ccls_subjects => :environment do
		race = Race.find_or_create_by_name("TEST RACE")
		subject_type = SubjectType.find_or_create_by_description("TEST TYPE")
		[	
			%w( 000000001 Jake      jakewendt@berkeley.edu ),
			%w( 000000002 Monique   modoes@berkeley.edu ),
			%w( 000000003 Catherine cmetayer@berkeley.edu ),
			%w( 000000004 Magee     magee@berkeley.edu ),
			%w( 000000005 Alice     aykang@berkeley.edu ),
			%w( 000000006 Karen     kbartley@berkeley.edu ),
			%w( 000000007 Helen     helenreed@berkeley.edu ),
			%w( 000000008 Ling-i    lingi.hsu@berkeley.edu ),
			%w( 000000009 Evan      evanb@berkeley.edu ),
			%w( 000000010 Steve     ssfrancis@berkeley.edu ),
			%w( 000000011 Todd      toddpwhitehead@berkeley.edu )
		].each do |ccls|
			Subject.create!({
				:race_id => race.id,
				:subject_type_id => subject_type.id,
				:pii_attributes => {
					:ssn         => ccls[0],
					:state_id_no => ccls[0],
					:first_name  => ccls[1],
					:email       => ccls[2]
				}
			})
		end
	end

	desc "DEV: Add some subjects"
	task :add_subjects => :environment do
		race = Race.find_or_create_by_name("TEST RACE")
		subject_type = SubjectType.find_or_create_by_description("TEST TYPE")
		10.times do |i|
			Subject.create({
				:race_id => race.id,
				:subject_type_id => subject_type.id
			})
		end
	end

	desc "Add some package tracking numbers"
	task :add_packages => :environment do
		puts "Adding Packages"
		%w( 134619889171013 134619889171020 
				918192619433536 918192619433550 918192619433567 
				918192619433710 918192619433734 
				450043071490 450043071505 ).each do |tn|
			puts " - Adding package with tracking number:#{tn}:"
			Package.find_or_create_by_tracking_number(tn)
		end
	end

end
