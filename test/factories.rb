Factory.define :user do |f|
	f.sequence(:uid) { |n| "foo#{n}" }
end

Factory.define :admin_user, :parent => :user do |f|
	f.administrator true
end

Factory.define :page do |f|
	f.sequence(:path) { |n| "/path#{n}" }
	f.sequence(:title) { |n| "My Page Title #{n}" }
	f.body  "Page Body"
end

