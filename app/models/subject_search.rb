class SubjectSearch < Search

	@@searchable_attributes = [
		:race, :type, :races, :types
	]

	def subjects
		@subjects = Subject.find(:all, 
			:joins => joins,
			:conditions => conditions)
	end

private	#	THIS IS REQUIRED

	def races_joins
		:race unless races.blank?
	end

	def races_conditions
		['races.description IN (?)', *races] unless races.blank?
	end

	def type_joins
		:subject_type unless types.blank?
	end

	def type_conditions
		['subject_types.description IN (?)', *types] unless types.blank?
	end

end
