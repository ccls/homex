class AddIndexToResponseSets < ActiveRecord::Migration
  def self.up
		table_name = 'response_sets'
		idxs = indexes(table_name).map(&:name)
    add_index(table_name, :access_code, :name => 'response_sets_ac_idx'
			) unless idxs.include?("response_sets_ac_idx")
  end

  def self.down
    remove_index(:response_sets, :name => 'response_sets_ac_idx')
  end
end
