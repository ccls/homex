namespace :app do

	desc "Load some fixtures to database for application"
	task :update => :environment do
		fixtures = %w(
			roles
		)
		ENV['FIXTURES'] = fixtures.join(',')
		puts "Loading fixtures for #{ENV['FIXTURES']}"
		Rake::Task["db:fixtures:load"].invoke
	end

	desc "DEPRECATING: Load some fixtures and users to database for application"
	task :setup => :update do
		Rake::Task["ccls:add_users"].invoke
		ENV['uid'] = '859908'
		Rake::Task["ccls:deputize"].invoke
		ENV['uid'] = '228181'
		Rake::Task["ccls:deputize"].reenable	#	<- this is stupid!
		Rake::Task["ccls:deputize"].invoke
	end

	task :full_update => :update do
		fixtures = %w(
			users
			pages
			guides
		)
		ENV['FIXTURES'] = fixtures.join(',')
		ENV['FIXTURES_PATH'] = 'production/fixtures'
		puts "Loading production fixtures for #{ENV['FIXTURES']}"
		Rake::Task["db:fixtures:load"].invoke
		Rake::Task["db:fixtures:load"].reenable
		User.all.each do |user|
			User.find_create_and_update_by_uid(user.uid)
		end
		User.find_by_uid('859908').deputize
		User.find_by_uid('228181').deputize
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
				450043071490 450043071505 065140275594099 ).each do |tn|
			puts " - Adding package with tracking number:#{tn}:"
			Package.find_or_create_by_tracking_number(tn)
		end
	end

end
