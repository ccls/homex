class AddIndexToSurveys < ActiveRecord::Migration
  def self.up
		table_name = 'surveys'
		idxs = indexes(table_name).map(&:name)
    add_index(table_name, :access_code, :name => 'surveys_ac_idx'
			) unless idxs.include?("surveys_ac_idx")
  end

  def self.down
    remove_index(:surveys, :name => 'surveys_ac_idx')
  end
end
