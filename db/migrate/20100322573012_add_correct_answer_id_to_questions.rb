class AddCorrectAnswerIdToQuestions < ActiveRecord::Migration
	def self.up
		table_name = 'questions'
		cols = columns(table_name).map(&:name)
		add_column( table_name, :correct_answer_id, :integer
			) unless cols.include?('correct_answer_id')
	end

	def self.down
		remove_column :questions, :correct_answer_id
	end
end
