module ResponseSetExtensions
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			# Same as typing in the class

			#	I still don't like this tactic. The access_code
			#	NEEDs to be unique, but is just a collection of 10
			#	purely random characters as can be seen in ...
			#	lib/surveyor.rb's make_tiny_code()
			#	It is certainly unlikely, but not impossible, that
			#	2 access_code's could end up being the same.
			#	This common idea that using cryptic text strings
			#	as opposed to a guaranteed unique integer is
			#	bothersome, but for the moment I'm not doing anything
			#	to remedy it.  I've added this validation, as well as
			#	a unique index in the db to prevent the creation.
			#	I suspect that the collision will occur
			#	and ResponseSet.create will return false which will
			#	generate the misleading flash[:notice] ...
			#	"Unable to find that survey".
			validates_uniqueness_of :access_code
		end
	end
	
	module ClassMethods
	end
	
	module InstanceMethods
		#	Collect all of the question and answers coded for
		#	the Home Exposures questionnaire.
		# >> ResponseSet.last.q_and_a_codes
		# => [["how_often_vacuumed_12mos", "1"], ["someone_ate_meat_12mos", "1"], ["freq_grilled_meat_outside_12mos", "2"], ["doneness_of_meat_exterior_12mos", "3"], ["shoes_usually_off_inside_12mos", "1"], ["vacuum_has_disposable_bag", "1"], ["other_pest_community_sprayed", "dogs"], ["cmty_sprayed_other_pest_12mos", "1"], ["home_square_footage", 100], ["year_home_built", 1900], ["number_of_rooms_in_home", 5]]
		def q_and_a_codes
			self.responses.collect(&:q_and_a_codes)
		end
		
		#	Collect all of the question and answers coded for
		#	the Home Exposures questionnaire.
		#	>> ResponseSet.last.q_and_a_codes_as_attributes
		#	=> {"doneness_of_meat_exterior_12mos"=>"3", "vacuum_has_disposable_bag"=>"1", "freq_grilled_meat_outside_12mos"=>"2", "someone_ate_meat_12mos"=>"1", "number_of_rooms_in_home"=>5, "how_often_vacuumed_12mos"=>"1", "year_home_built"=>1900, "shoes_usually_off_inside_12mos"=>"1", "home_square_footage"=>100, "cmty_sprayed_other_pest_12mos"=>"1", "other_pest_community_sprayed"=>"dogs"}
		#
		#	>> HomeExposureQuestionnaire.create(
		#		ResponseSet.find(7).q_and_a_codes_as_attributes)
		def q_and_a_codes_as_attributes
			Hash[*self.responses.collect(&:q_and_a_codes).flatten]
		end

		def is_complete?
			#	eventually return the is_complete column value
#			false
			!self.completed_at.nil?
		end
		#	ResponseSet access_code not guaranteed to be unique
		#
		#As there is no model validation or unique index in the database, 
		#	there is no guarantee that your response_set access_code will be 
		#	unique. It is just the output from Surveyor.make_tiny_code which 
		#	is just 10 randomly selected characters.  The character set is 
		#	upper and lower case letters plus digits, giving a set size of 62.  
		#	I concede that 62 ^ 10 is a HUGE number, but each time a survey 
		#	is taken, the possibility of those 10 randomly selected characters 
		#	already existing goes up. 
		#
		#In the ridiculously unlikely chance that a duplicate access_code 
		#	is created, when the create action redirects to the edit action, 
		#	the response set will be the first one and not the one just created.
		#
		#<pre>
		#@response_set = ResponseSet.find_by_access_code(params[:response_set_code])
		#</pre>
		#
		#Update....
		#
		#Adding ...
		#<pre>
		#def access_code=(value)
		#  while ResponseSet.find_by_access_code(value)
		#    value = Surveyor.make_tiny_code
		#  end
		#  super
		#end
		#</pre>
		#... to ResponseSet seems to "fix" this "problem", although I don't 
		#	know how kosher it is.
		#	Override the setting of the access_code to ensure its uniqueness
		def access_code=(value)
			while ResponseSet.find_by_access_code(value)
				value = Surveyor.make_tiny_code
			end
			super		#(value)
		end
		
	end
end

ResponseSet.send(:include, ResponseSetExtensions)
