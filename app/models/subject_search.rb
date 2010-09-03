# don't know exactly
class SubjectSearch < Search

	@@searchable_attributes = [
#		:race, :type, :races, :types, :vital_statuses
		:races, :types, :vital_statuses, :q,
		:sample_outcome, :interview_outcome,
		:projects
	]

#	includes= [:pii,:identifier]

	def subjects
		@subjects ||= Subject.send(
			(paginate)?'paginate':'all',{
				:include => [:pii,:identifier],
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

	def valid_orders
		%w( id childid last_name first_name dob studyid )
	end

private	#	THIS IS REQUIRED

	#	we should probably keep this more MySQL than Rails

	def order
		if valid_orders.include?(@order)
			order_string = case @order
				when 'childid'    then 'identifiers.childid'
				when 'last_name'  then 'piis.last_name'
				when 'first_name' then 'piis.first_name'
				when 'dob'        then 'piis.dob'
				when 'studyid'    then 'identifiers.patid'
				else @order
			end
			dir = case @dir.try(:downcase)
				when 'desc' then 'desc'
				else 'asc'
			end
			[order_string,dir].join(' ')
		else
			nil
		end
	end

	def vital_statuses_joins
		"INNER JOIN vital_statuses ON vital_statuses.id " <<
			"= subjects.vital_status_id" unless vital_statuses.blank?
	end

	def vital_statuses_conditions
		['vital_statuses.code IN (?)', vital_statuses
			] unless vital_statuses.blank?
	end

	def races_joins
		"INNER JOIN races ON races.id = subjects.race_id" unless races.blank?
	end

	def races_conditions
		['races.description IN (?)', races
			] unless races.blank?
	end

	def types_joins
		"INNER JOIN subject_types ON subject_types.id " <<
			"= subjects.subject_type_id" unless types.blank?
	end

	def types_conditions
		['subject_types.description IN (?)', types
			] unless types.blank?
	end

	def q_conditions
		unless q.blank?
			c = []
			v = {}
			q.to_s.split(/\s+/).each_with_index do |t,i|
				c.push("piis.first_name LIKE :t#{i}")
				c.push("piis.last_name LIKE :t#{i}")
				c.push("identifiers.patid LIKE :t#{i}")
				c.push("identifiers.childid LIKE :t#{i}")
				v["t#{i}".to_sym] = "%#{t}%"
			end
			[ "( #{c.join(' OR ')} )", v ]
		end
	end

	#	join order matters and this MUST come before
	#	those that join on home_outcomes!  Hmm?
	#	How?  Added a sort to joins and an "a_" to this
	def a_homex_outcome_joins
		"LEFT JOIN homex_outcomes ON homex_outcomes.subject_id " <<
			"= subjects.id" unless 
				sample_outcome.blank? && interview_outcome.blank?
	end

	def sample_outcome_joins
		"LEFT JOIN sample_outcomes ON sample_outcomes.id = " <<
			"homex_outcomes.sample_outcome_id" unless
				sample_outcome.blank?
	end

	def sample_outcome_conditions
		unless sample_outcome.blank?
			if sample_outcome =~ /^Complete$/i
				['sample_outcomes.code = ?',sample_outcome]
			else
				["(sample_outcomes.code != 'Complete' " <<
						"OR sample_outcomes.code IS NULL)"]
			end
		end
	end

	def interview_outcome_joins
		"LEFT JOIN interview_outcomes ON interview_outcomes.id = " <<
			"homex_outcomes.interview_outcome_id" unless
				interview_outcome.blank?
	end

	def interview_outcome_conditions
		unless interview_outcome.blank?
			if interview_outcome =~ /^Complete$/i
				['interview_outcomes.code = ?', interview_outcome]
			else
				["(interview_outcomes.code != 'Complete'" <<
					"OR interview_outcomes.code IS NULL)"]
			end
		end
	end

	def projects_joins
		unless projects.blank?
			s = ''
			projects.keys.each do |id|
				s << "JOIN enrollments proj_#{id} ON subjects.id "<<
						"= proj_#{id}.subject_id AND proj_#{id}.project_id = #{id} " 
			end
			s
		end
	end

	def projects_conditions
		unless projects.blank?
			conditions = []
			values = []
			projects.each do |id,attributes|
				attributes.each do |attr,val|
					val = [val].flatten
					if val.true_xor_false?
						conditions << case attr.to_s.downcase
							when 'eligible'
								"proj_#{id}.is_eligible " <<
									((val.true?)?'= 1':'!= 1')
							when 'candidate'
								"proj_#{id}.is_candidate " <<
									((val.true?)?'= 1':'!= 1')
							when 'chosen'
								"proj_#{id}.is_chosen " <<
									((val.true?)?'= 1':'!= 1')
							when 'consented'
								"proj_#{id}.consented " <<
									((val.true?)?'= 1':'!= 1')
							when 'terminated'
								"proj_#{id}.terminated_participation " <<
									((val.true?)?'= 1':'!= 1')
							when 'closed'
								"proj_#{id}.is_closed " <<
									((val.true?)?'= 1':'!= 1')
							when 'completed'
								"proj_#{id}.completed_on IS " <<
									((val.true?)?'NOT NULL':'NULL')
						end	#	case attr.to_s.downcase
					end	#	if val.true_xor_false?
				end	#	attributes.each
			end #	projects.each
			[conditions.compact,values].flatten(1)
		end #	unless projects.blank?
	end	#	def projects_conditions

end
