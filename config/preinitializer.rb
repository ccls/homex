Dir.glob(
	File.join(RAILS_ROOT,'lib/plugins/*/preinitializer.rb')
) + Dir.glob(
	File.join(RAILS_ROOT,'{lib,vendor}/plugins/*/rails/preinitializer.rb')
).each do |preinitializer|
	require(preinitializer)
end
