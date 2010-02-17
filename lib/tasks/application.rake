namespace :app do

#	task :args_as_array do
#		args = $*.dup.slice(1..-1)
#		puts args.collect {|arg| "X:" << arg }.join("\n")
#		exit
#	end

	desc "Add initial pages."
	task :add_pages => :environment do
		unless p = Page.find_by_path("/home")
			Page.create({
				:title => "Home Page Title",
				:path  => "/home",
				:body  => "Home Page Body"
			})
		end
		unless p = Page.find_by_path("/about")
			Page.create({
				:title => "About Page Title",
				:path  => "/about",
				:body  => "About Page Body"
			})
		end
	end

	desc "Deputize user by UID"
	task :deputize => :environment do
		puts
		if ENV['uid'].blank?
			puts "User's CalNet UID required."
			puts "Usage: rake #{$*} uid=INTEGER"
			puts
			exit
		end
		if !User.exists?(:uid => ENV['uid'])
			puts "No user found with uid=#{ENV['uid']}."
			puts
			exit
		end
		user = User.find(:first, :conditions => { :uid => ENV['uid'] })
		puts "Found user #{user.displayname}.  Deputizing..."
		user.deputize
		puts "User deputized: #{user.is_admin?}"
		puts
	end

end
