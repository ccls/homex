Dir.glob(
	File.join(RAILS_ROOT,'vendor/plugins/*/rails/preinitializer.rb')
).each do |preinitializer|
	load(preinitializer)
end
