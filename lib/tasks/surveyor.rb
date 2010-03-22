$VERBOSE = nil
if surveyor_gem = Gem.searcher.find('surveyor')
  Dir["#{surveyor_gem.full_gem_path}/lib/tasks/*.rake"].each { |ext| load ext }
end

namespace :survey do

	desc "Extract results"
	task :extract => :environment do
		puts
		if ENV['id'].blank?
			puts "Response Set ID required."
			puts "Usage: rake #{$*} id=INTEGER"
			puts
			exit
		end
		if !ResponseSet.exists?(:id => ENV['id'])
			puts "No response set found with id=#{ENV['id']}."
			puts
			exit
		end
		rs = ResponseSet.find(ENV['id'])
		puts "Found response set #{rs.access_code}."
		puts


		rs.responses.each do |r|
			puts "Question: " << r.question.data_export_identifier << " - " <<
				r.question.text
			puts "Answer: " << r.answer.data_export_identifier << " - " <<
				r.answer.text
			puts "Answer response class: " << r.answer.response_class
#			puts "\tdatetime_value:" << r.datetime_value.to_s
#			puts "\tinteger_value:" << r.integer_value.to_s
#			puts "\tfloat_value:" << r.float_value.to_s
#			puts "\tunit:" << r.unit.to_s
#			puts "\ttext_value:" << r.text_value.to_s
#			puts "\tstring_value:" << r.string_value.to_s
#			puts "\tresponse_other:" << r.response_other.to_s
#			puts "\tresponse_group:" << r.response_group.inspect	#	????
			puts
		end

	end


end
