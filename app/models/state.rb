class State < ActiveRecord::Base
	acts_as_list
	validates_presence_of :code, :name, :fips_state_code, :fips_country_code
	validates_uniqueness_of :code, :name, :fips_state_code

	# Returns an array of state abbreviations.
	def self.abbreviations
		@@abbreviations ||= all.collect(&:code)
	end

end
