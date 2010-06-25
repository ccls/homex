namespace :app do

#	task :args_as_array do
#		args = $*.dup.slice(1..-1)
#		puts args.collect {|arg| "X:" << arg }.join("\n")
#		exit
#	end

	desc "Load some fixtures to database for application"
	task :setup => :environment do
		fixtures = []
		fixtures.push('address_types')
		fixtures.push('pages')
		fixtures.push('races')
		fixtures.push('roles')
		fixtures.push('study_events')
		fixtures.push('subject_types')
		fixtures.push('units')
		ENV['FIXTURES'] = fixtures.join(',')
		puts "Loading fixtures for #{ENV['FIXTURES']}"
		Rake::Task["db:fixtures:load"].invoke
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

	desc "Add some expected users."
	task :add_users => :environment do
		puts "Adding users"
		%w( 859908 228181 855747 214766 180918 66458 808 768475 
			10883 86094 754783 769067 740176 315002 854720 16647 ).each do |uid|
			puts " - Adding user with uid:#{uid}:"
			User.find_create_and_update_by_uid(uid)
		end
	end

	desc "Deputize user by UID"
	task :deputize => :environment do
		puts
		if ENV['uid'].blank?
			puts "User's CalNet UID required."
			puts "Usage: rake #{$*} uid=INTEGER"
			puts
			exit
		end
		if !User.exists?(:uid => ENV['uid'])
			puts "No user found with uid=#{ENV['uid']}."
			puts
			exit
		end
		user = User.find(:first, :conditions => { :uid => ENV['uid'] })
		puts "Found user #{user.displayname}.  Deputizing..."
		user.deputize
		puts "User deputized: #{user.administrator?}"
		puts
	end

end

def nine_digit_number
	@ndn ||= 200
	@ndn += 1
	sprintf("%09d",@ndn) 
end
