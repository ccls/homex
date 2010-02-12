#
#	This is from Advanced Rails Recipes, page 277
#
namespace :test do
	
	desc 'Tracks test coverage with rcov'
	task :coverage do
#	task :coverage => :environment do
		rm_f "coverage"
		rm_f "coverage.data"
		
		unless PLATFORM['i386-mswin32']
#	Added smtp_tls to the -x as emails aren't sent in testing
#	Added authenticated_test_helper to the -x as lib/authenticated_test_helper isn't totally tested
#	Added authenticated_system to the -x as lib/authenticated_system isn't totally tested
			rcov = "rcov --sort coverage --rails --aggregate coverage.data " <<
							"--text-summary -Ilib -T -x gems/*,rcov*,smtp_tls," <<
							"authenticated_system,array_extension" 
#							"authenticated_system,hash_extension,array_extension,nil_class_extension" 
		else
			rcov = "rcov.cmd --sort coverage --rails --aggregate coverage.data --text-summary -Ilib -T"
		end
		
		system("#{rcov} --no-html test/unit/*_test.rb")
		system("#{rcov} --no-html test/functional/*_test.rb")
		system("#{rcov} --html test/integration/*_test.rb")
		
		unless PLATFORM['i386-mswin32']
			system("open coverage/index.html") if PLATFORM['darwin']
		else
			system("\"C:/Program Files/Mozilla Firefox/firefox.exe\" " +
						 "coverage/index.html")
		end
	end
end
