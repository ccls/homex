namespace :app do

#	task :args_as_array do
#		args = $*.dup.slice(1..-1)
#		puts args.collect {|arg| "X:" << arg }.join("\n")
#		exit
#	end

	desc "Prepare database for application"
	task :setup => :populate

	desc "Add a bunch of stuff to the DB"
	task :populate => [ 
#		:add_users, 		#	TODO
#		:add_packages, 
		:add_study_events,
		:add_races,
		:add_address_types,
		:add_pages
	]

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

	desc "Add address_types"
	task :add_address_types => :environment do
		puts "Adding Address Types"
		[
			{:code => "Home",:description => "address of residence of subject"},
			{:code => "Mailing", :description => "mailing address"}
		].each do |attrs|
			AddressType.find_or_create_by_code(attrs)
		end
	end

	desc "Add StudyEvents"
	task :add_study_events => :environment do
		puts "Adding Study Events"
		[ "Home Exposure" ].each do |d|
			StudyEvent.find_or_create_by_description(d)
		end
	end

	desc "Add races"
	task :add_races => :environment do
		puts "Adding Races"


	end

	desc "Add some package tracking numbers"
	task :add_packages => :environment do
		puts "Adding Packages"
		%w( 077973360403984 134619889171013 134619889171020 
				918192619433536 918192619433550 918192619433567 
				918192619433710 918192619433734 
				450043071490 450043071505 ).each do |tn|
			puts " - Adding package with tracking number:#{tn}:"
			Package.find_or_create_by_tracking_number(tn)
		end
	end

	desc "Add some expected users."
	task :add_users => :environment do		#	TODO
puts "This is temporarily disabled due to changes in User model"
#		puts "Adding users"
#		%w( 859908 228181 855747 214766 279143 180918 66458 808 768475 
#			10883 86094 754783 769067 740176 315002 854720 16647 ).each do |uid|
#			puts " - Adding user with uid:#{uid}:"
#			User.find_create_and_update_by_uid(uid)
#		end
	end

	desc "Add initial pages."
	task :add_pages => :environment do
#
#	Due to the bulk and simplicity, I'm considering creating 
#	fixtures for these.  It might be nice to have them for
#	testing as well.
#
		puts "Adding Default Pages"
		home = Page.find_or_create_by_path(
			:path  => "/", 
			:title => "CCLS",
			:menu  => "CCLS",
			:body  => "CCLS Page Body"
		)
		about = Page.find_or_create_by_path(
			:path  => "/about",
			:title => "About",
			:menu  => "About",
			:body  => "About Page Body"
		)
		Page.find_or_create_by_path(
			:path  => "/goals",
			:title => "Goals",
			:menu  => "Goals",
			:body  => "Goals Page Body",
			:parent_id => about.id
		)
		Page.find_or_create_by_path(
			:path  => "/staffbios",
			:title => "Staff Bios",
			:menu  => "Staff Bios",
			:body  => "Staff Bios Page Body",
			:parent_id => about.id
		)
		Page.find_or_create_by_path(
			:path  => "/partners",
			:title => "Partners",
			:menu  => "Partners",
			:body  => "Partners Page Body",
			:parent_id => about.id
		)
		Page.find_or_create_by_path(
			:path  => "/funding",
			:title => "Funding",
			:menu  => "Funding",
			:body  => "Funding Page Body",
			:parent_id => about.id
		)
		Page.find_or_create_by_path(
			:path  => "/contactus",
			:title => "Contact",
			:menu  => "Contact",
			:body  => "Contact Page Body",
			:parent_id => about.id
		)
		families = Page.find_or_create_by_path(
			:path  => "/families",
			:title => "Families",
			:menu  => "Families",
			:body  => "Families Page Body"
		)
		Page.find_or_create_by_path(
			:path  => "/factsheet",
			:title => "Factsheet",
			:menu  => "Factsheet",
			:body  => "Factsheet Page Body",
			:parent_id => families.id
		)
		Page.find_or_create_by_path(
			:path  => "/links",
			:title => "Links",
			:menu  => "Links",
			:body  => "Links Page Body",
			:parent_id => families.id
		)
		research = Page.find_or_create_by_path(
			:path  => "/research",
			:title => "Research",
			:menu  => "Research",
			:body  => "Research Page Body"
		)
		Page.find_or_create_by_path(
			:path  => "/cclsprojects",
			:title => "Projects",
			:menu  => "Projects",
			:body  => "Projects Page Body",
			:parent_id => research.id
		)
		Page.find_or_create_by_path(
			:path  => "/publications",
			:title => "Publications",
			:menu  => "Publications",
			:body  => "Publications Page Body",
			:parent_id => research.id
		)
		Page.find_or_create_by_path(
			:path  => "/faq",
			:title => "FAQ",
			:menu  => "FAQ",
			:body  => "FAQ Page Body",
			:parent_id => research.id
		)
		news = Page.find_or_create_by_path(
			:path  => "/news",
			:title => "News",
			:menu  => "News",
			:body  => "News Page Body"
		)
		Page.find_or_create_by_path(
			:path  => "/findings",
			:title => "Findings",
			:menu  => "Findings",
			:body  => "Findings Page Body",
			:parent_id => news.id
		)
		Page.find_or_create_by_path(
			:path  => "/awards",
			:title => "Awards",
			:menu  => "Awards",
			:body  => "Awards Page Body",
			:parent_id => news.id
		)
		Page.find_or_create_by_path(
			:path  => "/privacy",
			:title => "Privacy",
			:menu  => "Privacy",
			:body  => "Privacy Page Body",
			:hide_menu => true
		)
		Page.find_or_create_by_path(
			:path  => "/terms",
			:title => "Terms",
			:menu  => "Terms",
			:body  => "Terms Page Body",
			:hide_menu => true
		)
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
#		user.deputize
		user.update_attribute(:role_name, 'administrator')
		puts "User deputized: #{user.administrator?}"
		puts
	end

end

def nine_digit_number
	@ndn ||= 200
	@ndn += 1
	sprintf("%09d",@ndn) 
end
