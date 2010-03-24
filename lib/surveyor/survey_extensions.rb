if surveyor_gem = Gem.searcher.find('surveyor')
	require surveyor_gem.full_gem_path + '/script/surveyor/parser'
	require surveyor_gem.full_gem_path + '/script/surveyor/survey'
end

module SurveyParser
module SurveyExtensions
	def self.included(base)
		base.class_eval do
			def initialize_with_title(obj, args, opts)
				initialize_without_title(obj, args, opts)
				counter = 2
				ac = self.access_code
				original_ac = self.access_code
				while( survey = ::Survey.find_by_access_code(ac) ) 
					ac = [original_ac,"_",counter].join
					counter += 1
				end
				self.access_code = ac
			end
			alias_method_chain :initialize, :title
		end
	end
end
end
SurveyParser::Survey.send(:include, SurveyParser::SurveyExtensions)
