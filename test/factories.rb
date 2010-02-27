Factory.define :address do |f|
end

Factory.define :aliquot_sample_format do |f|
	f.description "My Description"
end

Factory.define :context do |f|
	f.description "My Description"
end


Factory.define :interview_event do |f|
end

Factory.define :interview_type do |f|
	f.description "My Description"
end

Factory.define :interview_version do |f|
	f.description "My Description"
end

Factory.define :organization do |f|
	f.sequence(:name) { |n| "My Org Name #{n}" }
end

Factory.define :operational_event do |f|
end

Factory.define :operational_event_type do |f|
	f.description "My Description"
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

Factory.define :residence do |f|
end

Factory.define :sample_subtype do |f|
	f.description "My Description"
end

Factory.define :sample_type do |f|
	f.description "My Description"
end

Factory.define :study_event do |f|
	f.description "My Description"
end

Factory.define :subject_type do |f|
	f.description "My Description"
end

Factory.define :transfer do |f|
	f.association :from_organization, :factory => :organization
	f.association :to_organization,   :factory => :organization
#	f.association :aliquot
end

Factory.define :unit do |f|
	f.description "My Description"
end

Factory.define :user do |f|
	f.sequence(:uid) { |n| "foo#{n}" }
end
Factory.define :admin_user, :parent => :user do |f|
	f.administrator true
end	#	parent must be defined first
