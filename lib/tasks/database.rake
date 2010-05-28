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

#	Rake::Task['morning:make_coffee'].invoke
	task :import_csv_data => [
		'app:add_address_types',
		:import_subject_data,
		:import_address_data
	]

	desc "Import address data from CSV file"
	task :import_address_data => :environment do
		require 'fastercsv'
		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		#FasterCSV.foreach('DUMMY_ManipulatedData.csv', {
		#	:headers => true }) do |line|
		#	If you want the lineno, you need the file (f)
#		(f=FasterCSV.open('DUMMY_ManipulatedData.csv', 'rb',{
		(f=FasterCSV.open('dummy_addresses.csv', 'rb',{
#	subjectID,Address_Type_ID,Address_Line1,Address_City,Address_State,Address_Zip
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			subject = Subject.find_by_subjectid(line[0])
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
		#FasterCSV.foreach('DUMMY_ManipulatedData.csv', {
		#	:headers => true }) do |line|
		#	If you want the lineno, you need the file (f)
#		(f=FasterCSV.open('DUMMY_ManipulatedData.csv', 'rb',{
		(f=FasterCSV.open('dummy_subject_pii_etc.csv', 'rb',{
#	Childid,patID,Type,OrderNo,subjectID,sex,DOB,RefDate,InterviewDate,First_Name,Middle_Name,Last_Name,Mother_First_Name,Mother_Middle_Name,Mother_Maiden_Name,Mother_Last_Name,Father_First_Name,Father_Middle_Name,Father_Last_Name,Primary_Phone,Alternate_phone1,Alternate_phone2,Alternate_phone3
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			subject_type = SubjectType.find_or_create_by_description(
				line[2])

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
					:type => line[2],
					:orderno => line[3],
					:phone_primary => line[27],
					:phone_alternate => line[28],
					:phone_alternate_2 => line[29],
					:phone_alternate_3 => line[30]
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
			
#	dummy_subject_pii_etc.csv does not contain addresses

#			subject.residences.create(:address => Address.new({
#				:line_1 => line[19],
#				:city   => line[20],
#				:state  => line[21],
#				:zip    => line[22]
#			})) unless line.fields[19..22].join.blank?
#			
#			subject.residences.create(:address => Address.new({
#				:line_1 => line[23],
#				:city   => line[24],
#				:state  => line[25],
#				:zip    => line[26]
#			})) unless line.fields[23..26].join.blank?
			

#	use Time.parse to parse all dates (better than Date.parse)

#	need ssn, state_id_no in data (making it up now)
#	interviewdate is what?
#	rename phone number field names ?
#	datestorefdate, daystointerviewdate,calcrefdate,calcinterviewdate ??


# 0 .. 6
#"Childid","patID","Type","OrderNo","subjectID","sex","DOB",
#	7 .. 11
#	"RefDate","InterviewDate","First_Name","Middle_Name","Last_Name",
# 12 .. 14
# "Mother_First_Name","Mother_Middle_Name","Mother_Maiden_Name",
# 15 .. 17
# "Mother_Last_Name","Father_First_Name","Father_Middle_Name",
# 18
# "Father_Last_Name",
# 19 20
# "Address_Mailing_Line1","Address_Mailing_City",
# 21 22
# "Address_Mailing_State","Address_Mailing_Zip",
# 23 24
# "Address_Residence_Line1","Address_Residence_City",
# 25 26
# "Address_Residence_State","Address_Residence_Zip",
# 27 .. 29
# "Primary_Phone","Alternate_phone1","Alternate_phone2",
# 30 .. 32
# "Alternate_phone3","daysToRefDate","daysToInterviewDate",
# 33 34
# "calcRefDate","calcInterviewDate"

		end
	end

end
