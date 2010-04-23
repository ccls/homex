module ActiveRecordExtension

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods

		def untaint_column(*args)
			options = args.extract_options!
			default = options.has_key?(:default) ? options[:default].to_s : 'id'
			additionals = if options.has_key?(:additionals)
				case options[:additionals]
					when Array then options[:additionals]
					else [options[:additionals]]
				end
			else
				[]
			end
			column = args.first

			possible_columns = self.column_names.concat(additionals).collect{|s|s.to_s.downcase}
			column = ( column.blank? ) ? "" : column.to_s
#	Are all column names lowercase? Or can they be mixed or uppercase?
			( possible_columns.include?(column.downcase.squish) ) ? column.downcase.squish : default
		end

		def untaint_direction(direction)
			direction = ( direction.blank? ) ? "" : direction.to_s
			( %w(ASC DESC).include?(direction.upcase.squish) ) ? direction.upcase.squish : "ASC"
		end

		#	This is MySQL specific and therefore not explicitly tested.
		#	good for use like find :order => ignore_articles_in_order_by(:title)
		#	assuming that this is not accessible by user so it is not tainted
		def ignore_articles_in_order_by(column)
			return "IF(LEFT(#{column},2)='A ',SUBSTRING(#{column} FROM 3), " << 
				"IF(LEFT(#{column},3)='An ',SUBSTRING(#{column} FROM 4), " << 
				"IF(LEFT(#{column},4)='The ',SUBSTRING(#{column} FROM 5), #{column})))"
		end

		#	This is MySQL specific and therefore not explicitly tested.
		def table_status
			r=self.connection.execute("show table status where name = '#{self.table_name}'")
			r.fetch_hash
		end

		#	This is MySQL specific and therefore not explicitly tested.
		def auto_increment
			self.table_status['Auto_increment'].to_i
		end
		alias_method :next_id, :auto_increment


		def validates_belongs_to_exists(*args)
			options = args.extract_options!

			validates_each args do |record, attr, value|
				column = attr.to_s.sub(/_id$/,'')
				unless (column.camelcase.constantize.exists?(value))
					record.errors.add(attr,'is invalid') 
				end
			end

		end

	end

end
