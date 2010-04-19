class HomePagePic < ActiveRecord::Base
	validates_presence_of :title
	validates_length_of :title, :minimum => 4

	has_attached_file :image, :styles => {
		:full   => "900",
		:medium => "600",
		:small  => "150x50>"
	}

	class MissingAdapter < StandardError; end

	def self.random_active
#		#	there should be a better way.  a rails way.
#		#	This will cause code to be untested.
#		random = case adapter()
#			when "mysql"   then "RAND()"
#			when "sqlite3" then "Random()"
#			else raise MissingAdapter
#		end
#		first( :order => random, :conditions => { :active => true } )

		c = HomePagePic.count(:conditions => { :active => true } )
		first(:offset => rand(c), :conditions => { :active => true })
	end

protected

#	def self.adapter
#		@adapter ||= connection.instance_variable_get(:@config)[:adapter]
#	end

end
