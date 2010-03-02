class Page < ActiveRecord::Base
	acts_as_list
	validates_length_of :path,  :minimum => 4
	validates_length_of :title, :minimum => 4
	validates_length_of :body,  :minimum => 4
	validates_uniqueness_of :path
	
	attr_accessible :path, :title, :body

	after_validation :downcase_path
	def downcase_path
		self.path = path.try(:downcase)
	end

	def self.by_path(path)
		find(:first,
			:conditions => {
				:path => path.downcase
			}
		)
	end

end
