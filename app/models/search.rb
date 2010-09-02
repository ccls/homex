#
#	From http://railscasts.com/episodes/111-advanced-search-form
#
class Search

	@@searchable_attributes = []
	@@attr_accessors = [ :order, :dir, :includes, 
		:paginate, :per_page, :page ]
	attr_accessor *@@attr_accessors

private

	def valid_orders
		[]
	end

	def initialize(options={})
		self.class.send('attr_accessor', *@@searchable_attributes)
		options.each do |attr,value|
			if @@attr_accessors.include?(attr.to_sym) ||
				@@searchable_attributes.include?(attr.to_sym)
				self.send("#{attr}=",value)
			end
		end
	end

	def self.inherited(subclass)
#		puts "Subclassed by #{subclass}"
		#	Create 'shortcut'
		#	SubjectSearch(options) -> SubjectSearch.new(options)
		Object.class_eval do
			define_method subclass.to_s do |*args|
				subclass.send(:new,*args)
			end
		end
	end

	#	This may work for the simple stuff, but I suspect
	#	that once things get complicated, it will unravel.

	def conditions
		[conditions_clauses.join(' AND '), *conditions_options]
	end

	def conditions_clauses
		conditions_parts.map { |condition| condition.first }
	end

	def conditions_options
		#	conditions_parts.map { |condition| condition[1..-1] }.flatten
		#
		#	the above flatten breaks the "IN (?)" style search
		#
		#	conditions_parts.map { |condition| condition[1..-1] }
		#	This fixes it, but is kinda bulky
#		opts = []
#		conditions_parts.each do |condition|
#			condition[1..-1].each{|cp| opts << cp}
#		end
#		opts 
		#	That's better!
		conditions_parts.map { |condition| condition[1..-1] }.flatten(1)
	end

	def conditions_parts
		private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
	end

	def joins
		private_methods(false).grep(/_joins$/).map { |m| send(m) }.compact
	end

end
