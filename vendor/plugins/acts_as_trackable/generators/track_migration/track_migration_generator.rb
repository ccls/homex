class TrackMigrationGenerator < Rails::Generator::NamedBase

	def initialize(runtime_args, runtime_options = {})
		#	Rails::Generator::NamedBase apparently requires
		#	at least 1 argumnet.  The first will be used
		#	for things like migration class name
		runtime_args.unshift 'CreateTracksTable'
		super
	end

	def manifest
		record do |m|
			# m.directory "lib"
			# m.template 'README', "README"
			m.migration_template 'migration.rb', 'db/migrate'
		end
	end

end
