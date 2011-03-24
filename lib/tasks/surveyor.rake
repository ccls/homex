#
#	Loaded foxy fixture ids not guaranteed to be unique
#	
#	This is more of an FYI for those who may be interested and don't 
#	already know.  When using foxy fixtures, the id is generated based 
#	on the fixture label.  As the id is a finite, albeit large, number, 
#	it is not guaranteed to be unique.  A collision, intended in this 
#	case, can be demonstrated by ...
#	
#	<pre>
#	rake surveyor FILE=surveys/kitchen_sink_survey.rb APPEND=true
#	rake surveyor:load_fixtures APPEND=true
#	</pre>
#	
#	and should show something like
#	
#	<pre>
#	Loading ............../surveys/fixtures/answers.yml...
#	Appending, skipping delete...
#	rake aborted!
#	Mysql::Error: Duplicate entry '943057946' for key 'PRIMARY': 
#	INSERT INTO `answers` (`question_id`, `is_exclusive`, `created_at`, 
#	`updated_at`, `hide_label`, `text`, `response_class`, `id`, 
#	`short_text`, `display_order`, `reference_identifier`, 
#	`data_export_identifier`) VALUES (304607657, 0, '2010-03-24 23:21:39', 
#	'2010-03-24 23:21:39', 0, '2', 'answer', 943057946, '2', 5, NULL, '2')
#	</pre>
#	
#	In the random chance that this collision occurs on 2 labels that are 
#	not identical in the middle of a fixture load, you will be left with 
#	a mess.  The only foreseeable solution would be to regenerate the 
#	fixtures and try again.
#	


$VERBOSE = nil
if surveyor_gem = Gem.source_index.find_name('jakewendt-surveyor').first
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
			puts "Response.to_s :" << r.to_s

			response_code = if r.answer.response_class == "answer" 
				r.answer.data_export_identifier
			else
				r.send("#{r.answer.response_class}_value")
			end
			puts "#{r.question.data_export_identifier}:" <<
				"#{response_code}"
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
