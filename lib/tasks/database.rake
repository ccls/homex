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
					record.delete('created_at')
					record.delete('updated_at')
					hash["#{table_name}_#{record['id']}"] = record
					hash
				}.to_yaml
			end
		end
		exit
	end

	desc "Import subject and address data from CSV files"
	task :import_csv_data => [
		:import_subject_data,
		:import_address_data
	]

	task :random_project_subjects_data => :environment do 
		se = StudyEvent.find_or_create_by_description("Home Exposure")
		Subject.all.each do |s|
			puts s.id
			#	2440000 is sometime in 1968
			#	2455000 is sometime in 2009
			completed_on = ( rand > 0.5 ) ? Date.jd(2440000+rand(15000)) : nil
			ProjectSubject.create!({
				:subject => s,
				:study_event => se,
				:is_eligible => rand > 0.5,
				:is_chosen   => rand > 0.5,
				:consented   => rand > 0.5,
				:subject_terminated_participation => rand > 0.5,
				:is_closed   => rand > 0.5,
				:completed_on => completed_on
			})
#	Should add some of these and smarten it up a bit
#ineligible_reason_id: integer, 
#refusal_reason_id: integer, 
#reason_not_chosen: string, 
#recruitment_priority: string, 
#consented_on: date, 
#other_refusal_reason: string, 
#subject_terminated_reason: string, 
#reason_closed: string

		end
	end

	desc "Import address data from CSV file"
	task :import_address_data => :environment do
		require 'fastercsv'
		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('dummy_addresses.csv', 'rb',{
#	subjectID,Address_Type_ID,Address_Line1,Address_City,Address_State,Address_Zip
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			#	due to padding it with zeros, NEED this to be an Integer
			subject = Subject.find_by_subjectid(line[0].to_i)
			raise ActiveRecord::RecordNotFound unless subject

			address_type = AddressType.find_by_code(
				(line[1].to_s == '1')?'Home':'Mailing')
			raise ActiveRecord::RecordNotFound unless address_type

			address = Address.create!(
				:address_type => address_type,
				:line_1 => line[2],
				:city => line[3],
				:state => line[4],
				:zip => line[5]
			)

			Residence.create!(
				:subject => subject,
				:address => address
			)
		end
	end

	desc "Import subject data from CSV file"
	task :import_subject_data => :environment do
		require 'fastercsv'
		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('dummy_subject_pii_etc.csv', 'rb',{
#	Childid,patID,Type,OrderNo,subjectID,sex,DOB,RefDate,InterviewDate,First_Name,Middle_Name,Last_Name,Mother_First_Name,Mother_Middle_Name,Mother_Maiden_Name,Mother_Last_Name,Father_First_Name,Father_Middle_Name,Father_Last_Name,Primary_Phone,Alternate_phone1,Alternate_phone2,Alternate_phone3
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			subject_type = SubjectType.find_or_create_by_description('TEST')
#			subject_type = SubjectType.find_or_create_by_description(
#				line[2])

			#	TODO	(not included in csv)
			race = Race.find_or_create_by_name('TEST')			

			dob = (line[6].blank?)?'':Time.parse(line[6])
			refdate = (line[7].blank?)?'':Time.parse(line[7])
			interview_date = (line[8].blank?)?'':Time.parse(line[8])
			subject = Subject.create!({
				:child_id_attributes => { :childid => line[0] },
				:patient_attributes  => { },										#	TODO (patid)
				:pii_attributes => {
					:ssn => sprintf('%09d',line[0]),							#	TODO
					:state_id_no => sprintf('%09d',line[0]),			#	TODO
					:first_name  => line[9],
					:middle_name => line[10],
					:last_name   => line[11],
					:father_first_name  => line[16],
					:father_middle_name => line[17],
					:father_last_name   => line[18],
					:mother_first_name  => line[12],
					:mother_middle_name => line[13],
					:mother_maiden_name => line[14],
					:mother_last_name   => line[15],
					:dob => dob,
					:patid => line[1],
					:stype => line[2],
					:orderno => line[3],
					:phone_primary => line[19],
					:phone_alternate => line[20],
					:phone_alternate_2 => line[21],
					:phone_alternate_3 => line[22]
				},
				:subject_type => subject_type,
				:race => race,
				:subjectid => line[4],
				:sex => line[5],
				:reference_date => refdate
			})

			InterviewEvent.create!({
				:subject_id => subject.id,
				:began_on   => interview_date,
				:ended_on   => interview_date
			})
			
#	use Time.parse to parse all dates (better than Date.parse)

#	need ssn, state_id_no in data (making it up now)

		end
	end
end
