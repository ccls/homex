class Page < ActiveRecord::Base
	validates_length_of :path,  :minimum => 4
	validates_length_of :title, :minimum => 4
	validates_length_of :body,  :minimum => 4
	validates_uniqueness_of :path
	
	attr_accessible :path, :title, :body

	def self.by_path(path)
		find(:first,
			:conditions => {
				:path => path 
			}
		)
	end

end
