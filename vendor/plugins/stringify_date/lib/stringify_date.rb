# StringifyDate

## models/task.rb
#stringify_date :due_at
#
#def validate
#  errors.add(:due_at, "is invalid") if due_at_invalid?
#end

# stringify_date.rb
module StringifyDate
  def stringify_date(*names)
    names.each do |name|
      define_method "#{name}_string" do
        read_attribute(name).to_s(:db) unless read_attribute(name).nil?
      end
      
      define_method "#{name}_string=" do |date_str|
        if ( !date_str.blank? )
          begin
            write_attribute(name, Date.parse(date_str)) 
          rescue ArgumentError
            instance_variable_set("@#{name}_invalid", true)
          end
        else
          write_attribute(name,'')
        end
      end
      
      define_method "#{name}_invalid?" do
        instance_variable_get("@#{name}_invalid")
      end
    end
  end
end

