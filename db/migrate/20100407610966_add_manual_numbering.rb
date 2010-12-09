class AddManualNumbering < ActiveRecord::Migration
  def self.up
		table_name = 'surveys'
		cols = columns(table_name).map(&:name)
    add_column( table_name, :manual_numbering, :boolean
			) unless cols.include?('manual_numbering')
		table_name = 'questions'
		cols = columns(table_name).map(&:name)
    add_column( table_name, :number, :string
			) unless cols.include?('number')
  end

  def self.down
    remove_column :surveys, :manual_numbering
    remove_column :questions, :number
  end
end
