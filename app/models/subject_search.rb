# don't know exactly
class SubjectSearch < Search

	@@searchable_attributes = [
		:race, :type, :races, :types, :vital_statuses
	]

	includes= [:pii,:identifier]

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

	def vital_statuses_joins
		"INNER JOIN vital_statuses ON vital_statuses.id " <<
			"= subjects.vital_status_id" unless vital_statuses.blank?
	end

	def vital_statuses_conditions
		['vital_statuses.code IN (?)', *vital_statuses
			] unless vital_statuses.blank?
	end

	def races_joins
		"INNER JOIN races ON races.id = subjects.race_id" unless races.blank?
	end

	def races_conditions
		['races.description IN (?)', *races
			] unless races.blank?
	end

	def types_joins
		"INNER JOIN subject_types ON subject_types.id " <<
			"= subjects.subject_type_id" unless types.blank?
	end

	def types_conditions
		['subject_types.description IN (?)', *types
			] unless types.blank?
	end

end
#
#	This works for factory girl, but not for me??
#	This really should work.  Just make sure that the call includes ()
#	otherwise ruby will treat it like an undefined Constant.
#
#	def SubjectSearch(options={})
#		SubjectSearch.new(options)
#	end
