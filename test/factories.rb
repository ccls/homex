Factory.define :address do |f|
end

Factory.define :context do |f|
	f.description "My Description"
end

Factory.define :organization do |f|
	f.sequence(:name) { |n| "My Org Name #{n}" }
end

Factory.define :operational_event do |f|
end

Factory.define :page do |f|
	f.sequence(:path) { |n| "/path#{n}" }
	f.sequence(:title) { |n| "My Page Title #{n}" }
	f.body  "Page Body"
end

Factory.define :sample_subtype do |f|
	f.description "My Description"
end

Factory.define :sample_type do |f|
	f.description "My Description"
end

Factory.define :unit do |f|
	f.description "My Description"
end

Factory.define :user do |f|
	f.sequence(:uid) { |n| "foo#{n}" }
end
Factory.define :admin_user, :parent => :user do |f|
	f.administrator true
end

