Factory.define :user do |f|
	f.sequence(:uid) { |n| "foo#{n}" }
end

Factory.define :admin_user, :parent => :user do |f|
	f.administrator true
end

