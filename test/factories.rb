Factory.define :address do |f|
end

Factory.define :aliquot do |f|
	f.association :sample
	f.association :unit
end

Factory.define :aliquot_sample_format do |f|
	f.sequence(:description) { |n| "My Description #{n}" }
end

Factory.define :context do |f|
	f.sequence(:description) { |n| "My Description #{n}" }
end

Factory.define :ineligible_reason do |f|
	f.sequence(:description) { |n| "My Description #{n}" }
end

Factory.define :interview_event do |f|
	f.association :address
	f.association :subject
	f.association :interviewer, :factory => :person
end

Factory.define :interview_type do |f|
	f.sequence(:description) { |n| "My Description #{n}" }
	f.association :study_event
end

Factory.define :interview_version do |f|
	f.sequence(:description) { |n| "My Description #{n}" }
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
	f.sequence(:description) { |n| "My Description #{n}" }
	f.association :study_event
	f.association :interview_event
end

Factory.define :package do |f|
#	f.carrier "FedEx"
	f.sequence(:tracking_number) { |n| "ABC123#{n}" }
end

Factory.define :page do |f|
	f.sequence(:path) { |n| "/path#{n}" }
	f.sequence(:title) { |n| "My Page Title #{n}" }
	f.body  "Page Body"
end

Factory.define :person do |f|
end
Factory.define :interviewer, :parent => :person do |f|
end	#	parent must be defined first

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
	f.sequence(:description) { |n| "My Description #{n}" }
end

Factory.define :sample do |f|
	f.association :subject
	f.association :unit
end

Factory.define :sample_subtype do |f|
	f.association :sample_type
	f.sequence(:description) { |n| "My Description #{n}" }
end

Factory.define :sample_type do |f|
	f.sequence(:description) { |n| "My Description #{n}" }
end

Factory.define :study_event do |f|
	f.sequence(:description) { |n| "My Description #{n}" }
end

Factory.define :study_event_eligibility do |f|
	f.association :subject
	f.association :study_event
end

Factory.define :subject do |f|
	f.association :subject_type
	f.association :race
end

Factory.define :subject_type do |f|
	f.sequence(:description) { |n| "My Description #{n}" }
end

Factory.define :transfer do |f|
	f.association :from_organization, :factory => :organization
	f.association :to_organization,   :factory => :organization
	f.association :aliquot
end

Factory.define :unit do |f|
	f.sequence(:description) { |n| "My Description #{n}" }
end

Factory.define :user do |f|
	f.sequence(:uid) { |n| "foo#{n}" }
end
Factory.define :admin_user, :parent => :user do |f|
	f.administrator true
end	#	parent must be defined first
