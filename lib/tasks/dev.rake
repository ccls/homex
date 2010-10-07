namespace :dev do

	task :rip_codes => :environment do
		survey = Survey.find_by_access_code('home_exposure_survey')
		raise ActiveRecord::RecordNotFound unless survey

		survey.questions.each do |q|
			puts q.data_export_identifier
			q.answers.each do |a|
				puts " - #{a.data_export_identifier} : #{a.text}"
			end
		end
	end

end
