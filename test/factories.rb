Factory.define :address do |f|
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
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :child_id do |f|
	f.sequence(:childid) { |n| "#{n}" }
end

Factory.define :context do |f|
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :dust_kit do |f|
end

Factory.define :home_exposure_response do |f|
	f.association :subject
end

Factory.define :home_page_pic do |f|
	f.sequence(:title){ |n| "Title #{n}" }
end

Factory.define :ineligible_reason do |f|
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :interview_event do |f|
#	f.association :address
	f.association :subject
#	f.association :interviewer, :factory => :person
end

Factory.define :interview_type do |f|
	f.sequence(:description) { |n| "Desc#{n}" }
	f.association :study_event
end

Factory.define :interview_version do |f|
	f.sequence(:description) { |n| "Desc#{n}" }
	f.association :interview_event
	f.association :interview_type
end

Factory.define :organization do |f|
	f.sequence(:name) { |n| "My Org Name #{n}" }
end

Factory.define :operational_event do |f|
	f.association :subject
	f.association :operational_event_type
end

Factory.define :operational_event_type do |f|
	f.sequence(:description) { |n| "Desc#{n}" }
	f.association :study_event
	f.association :interview_event
end

Factory.define :package do |f|
#	f.carrier "FedEx"
	f.sequence(:tracking_number) { |n| "ABC123#{n}" }
end

Factory.define :page do |f|
	f.sequence(:path) { |n| "/path#{n}" }
	f.sequence(:menu) { |n| "Menu #{n}" }
	f.sequence(:title){ |n| "Title #{n}" }
	f.body  "Page Body"
end

Factory.define :patient do |f|
end

Factory.define :person do |f|
end
Factory.define :interviewer, :parent => :person do |f|
end	#	parent must be defined first

Factory.define :pii do |f|
#	f.association :subject
	f.first_name "First"
	f.middle_name "Middle"
	f.last_name "Last"
	f.sequence(:ssn){|n| sprintf("%09d",n) }
	f.sequence(:state_id_no){|n| "#{n}"}
	f.sequence(:patid){|n| "#{n}"}
#	f.sequence(:orderno){|n| "#{n}"}
#	This is just one digit so looping through all.
#	This is potentially a problem causer in testing.
	f.sequence(:orderno){|n| '0123456789'.split('')[n%10] }
#	f.sequence(:stype){|n| "#{n}"}
#	This is just one character so looping through known unused chars.
#	This is potentially a problem causer in testing.
	f.sequence(:stype){|n|
		'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')[n%36] }
	f.sequence(:email){|n| "email#{n}@example.com"}
	f.dob Date.jd(2440000+rand(15000))
end

Factory.define :project_subject do |f|
	f.association :subject
	f.association :study_event
end

Factory.define :race do |f|
	f.sequence(:name){|n| "Race#{n}"}
end

Factory.define :residence do |f|
	f.association :address
	f.association :subject
end

Factory.define :refusal_reason do |f|
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :role do |f|
	f.sequence(:name) { |n| "name#{n}" }
end

Factory.define :sample do |f|
	f.association :subject
	f.association :unit
end

Factory.define :sample_subtype do |f|
	f.association :sample_type
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :sample_type do |f|
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :study_event do |f|
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :study_event_eligibility do |f|
	f.association :subject
	f.association :study_event
end

Factory.define :subject do |f|
	f.association :subject_type
	f.association :race
	f.sequence(:subjectid){|n| "#{n}"}
end

Factory.define :subject_type do |f|
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
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :user do |f|
	f.sequence(:uid) { |n| "UID#{n}" }
#	f.sequence(:username) { |n| "username#{n}" }
#	f.sequence(:email) { |n| "username#{n}@example.com" }
#	f.password 'V@1!dP@55w0rd'
#	f.password_confirmation 'V@1!dP@55w0rd'
#	f.role_name 'user'
end
Factory.define :admin_user, :parent => :user do |f|
	f.administrator true
end	#	parent must be defined first

Factory.define :user_invitation do |f|
	f.association :sender, :factory => :user
	f.sequence(:email){|n| "invitation#{n}@example.com"}
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


