class SubjectSearch < Search

	@@searchable_attributes = [
		:race, :type, :races, :types
	]

	def subjects
		@subjects ||= Subject.send(
			(paginate)?'paginate':'all',{
				:include => includes,
				:order => order,
				:joins => joins,
				:conditions => conditions
			}.merge(
				(paginate)?{
					:per_page => per_page||25,
					:page     => page||1
				}:{}
			)
		)
	end

private	#	THIS IS REQUIRED

	#	we should probably keep this more MySQL than Rails

	def races_joins
		#	INNER JOIN `races` ON `races`.id = `subjects`.race_id
		:race unless races.blank?
	end

	def races_conditions
		['races.description IN (?)', *races] unless races.blank?
	end

	def types_joins
		:subject_type unless types.blank?
	end

	def types_conditions
		['subject_types.description IN (?)', *types] unless types.blank?
	end

end
