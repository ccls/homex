Factory.define :address do |f|
	f.association :subject
	f.association :address_type
	f.sequence(:line_1) { |n| "Box #{n}" }
	f.city "Berkeley"
	f.state "CA"
	f.zip "12345"
end

Factory.define :address_type do |f|
	f.sequence(:code) { |n| "Code#{n}" }
end

Factory.define :aliquot do |f|
	f.association :sample
	f.association :unit
#	f.association :aliquoter, :factory => :organization
	f.association :owner, :factory => :organization
end

Factory.define :aliquot_sample_format do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :analysis do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :identifier do |f|
	f.sequence(:childid) { |n| "#{n}" }
	f.sequence(:ssn){|n| sprintf("%09d",n) }
	f.sequence(:patid){|n| "#{n}"}
#	f.sequence(:orderno){|n| "#{n}"}
#	This is just one digit so looping through all.
#	This is potentially a problem causer in testing.
	f.sequence(:orderno){|n| '0123456789'.split('')[n%10] }
#	f.sequence(:stype){|n| "#{n}"}
#	This is just one character so looping through known unused chars.
#	This is potentially a problem causer in testing.
	f.sequence(:case_control_type){|n|
		'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')[n%36] }
end

Factory.define :context do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :data_source do |f|
end

Factory.define :dust_kit do |f|
end

Factory.define :hospital do |f|
end

Factory.define :homex_outcome do |f|
	f.association :subject
end

Factory.define :home_exposure_event do |f|
#	f.association :subject
end

Factory.define :home_exposure_response do |f|
	f.association :subject
end

Factory.define :home_page_pic do |f|
	f.sequence(:title){ |n| "Title #{n}" }
end

Factory.define :ineligible_reason do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :interview do |f|
#	f.association :address
#	f.association :subject
#	f.association :interviewer, :factory => :person
end

Factory.define :interview_method do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :interview_outcome do |f|
	f.sequence(:code) { |n| "Code#{n}" }
end

Factory.define :interview_type do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
	f.association :project
end

Factory.define :interview_version do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
	f.association :interview_type
#	f.association :language
end

Factory.define :language do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :organization do |f|
	f.sequence(:code) { |n| "My Org Code #{n}" }
	f.sequence(:name) { |n| "My Org Name #{n}" }
end

Factory.define :operational_event do |f|
	f.association :subject
	f.association :operational_event_type
end

Factory.define :operational_event_type do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :package do |f|
#	f.carrier "FedEx"
	f.sequence(:tracking_number) { |n| "ABC123#{n}" }
end

Factory.define :patient do |f|
end

Factory.define :person do |f|
end

Factory.define :pii do |f|
#	f.association :subject
	f.first_name "First"
	f.middle_name "Middle"
	f.last_name "Last"
	f.sequence(:state_id_no){|n| "#{n}"}
	f.sequence(:email){|n| "email#{n}@example.com"}
	f.dob Date.jd(2440000+rand(15000))
end

Factory.define :enrollment do |f|
	f.association :subject
	f.association :project
end

Factory.define :race do |f|
	f.sequence(:code){|n| "Race#{n}"}
	f.sequence(:description){|n| "Desc#{n}"}
end

Factory.define :residence do |f|
	f.association :address
end

Factory.define :refusal_reason do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :sample do |f|
	f.association :subject
	f.association :unit
	f.association :sample_type
end

Factory.define :sample_kit do |f|
	f.association :sample
end

Factory.define :sample_outcome do |f|
	f.sequence(:code) { |n| "Code#{n}" }
end

Factory.define :sample_type do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :project do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :subject do |f|
	f.association :subject_type
	f.association :race
	f.association :vital_status
	f.sequence(:subjectid){|n| "#{n}"}
	f.sequence(:sex){|n|
		%w( male female )[n%2] }
end

Factory.define :subject_type do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :survey_invitation do |f|
	f.association :survey
	f.association :subject
end


Factory.define :track do |f|
	f.association :trackable, :factory => :package
	f.name "Name"
	f.time Time.now
end

Factory.define :transfer do |f|
	f.association :from_organization, :factory => :organization
	f.association :to_organization,   :factory => :organization
	f.association :aliquot
end

Factory.define :unit do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :vital_status do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end


#
#		Intended for communication with SRC,
#		but that doesn't look like it'll be happening now.
#
Factory.define :import do |f|
end
Factory.define :export do |f|
	f.sequence(:childid) { |n| "childid#{n}" }
	f.sequence(:patid) { |n| "patid#{n}" }
end





#
#		Survey related factories
#
Factory.define :survey do |f|
	f.sequence(:title){|n| "My Survey #{n}" }
end
Factory.define :survey_section do |f|
	f.association :survey
	f.sequence(:title) { |n| "Title #{n}" }
	f.sequence(:display_order){ |n| n }
end
Factory.define :response_set do |f|
	f.association :subject
	f.association :survey
end
Factory.define :response do |f|
	f.association :response_set
	f.association :question
	f.association :answer
end
Factory.define :question do |f|
	f.association :survey_section
	f.sequence(:display_order){ |n| n }
	f.text "My Question Text"
	f.is_mandatory false
	f.sequence(:data_export_identifier){|n| "qdei_#{n}" }
end
Factory.define :answer do |f|
	f.association :question
	f.text "My Answer Text"
	f.sequence(:data_export_identifier){|n| "adei_#{n}" }
#	f.response_class "answer"
end


