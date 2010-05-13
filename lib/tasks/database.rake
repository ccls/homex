namespace :db do

	desc "Create yml fixtures for given model in database\n" <<
	     "rake db:extract_fixtures_from pages"
	task :extract_fixtures_from => :environment do
		me = $*.shift
		while( table_name = $*.shift )
			File.open("#{RAILS_ROOT}/db/#{table_name}.yml", 'w') do |file|
				data = table_name.singularize.capitalize.constantize.find(
					:all).collect(&:attributes)
				file.write data.inject({}) { |hash, record|
#					record.delete('created_at')
#					record.delete('updated_at')
					hash["#{table_name}_#{record['id']}"] = record
					hash
				}.to_yaml
			end
		end
		exit
	end

	desc "Import subject data from CSV file"
	task :import_subject_data => :environment do
#		last_length = 0
		(f = File.open('DUMMY_ManipulatedData.csv','r')).each do |line|
#	fortunately, all lines are 35 fields with no commas in fields
#	which makes parsing much simpler.
#			length = line.split(',').length
#			if length != last_length
#				puts "Changed from #{last_length} to #{length}"
#				last_length = length
#			end

			if line =~ /^\s*#/
				puts "Skipping commented line: #{f.lineno}"
				next 
			end
			#puts f.lineno
		end
	end

end
