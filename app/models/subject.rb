class Subject < Ccls::Subject

	class NotTwoResponseSets < StandardError; end

	has_many :response_sets, :foreign_key => 'study_subject_id'

	def response_sets_the_same?
		if response_sets.length == 2
			#	response_sets.inject(:is_the_same_as?) was nice
			#	but using inject is ruby >= 1.8.7
			return response_sets[0].is_the_same_as?(response_sets[1])
		else
			raise Subject::NotTwoResponseSets
		end
	end

	def response_set_diffs
		if response_sets.length == 2
			#	response_sets.inject(:diff) was nice
			#	but using inject is ruby >= 1.8.7
			return response_sets[0].diff(response_sets[1])
		else
			raise Subject::NotTwoResponseSets
		end
	end

end
