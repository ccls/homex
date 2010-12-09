class RenameSubjectToStudySubject < ActiveRecord::Migration
	def self.up
		[ :response_sets ].each do |t|
			remove_index t, :subject_id
		end
		remove_index :survey_invitations, [:survey_id, :subject_id]

		[ :response_sets, :survey_invitations ].each do |t|
			rename_column t, :subject_id, :study_subject_id
		end

		[ :response_sets ].each do |t|
			add_index t, :study_subject_id
		end
		add_index :survey_invitations, [:survey_id, :study_subject_id], :unique => true
	end

	def self.down
		remove_index  :survey_invitations, [:survey_id, :study_subject_id]
		[ :response_sets ].each do |t|
			remove_index  t, :study_subject_id
		end

		[ :response_sets,:survey_invitations ].each do |t|
			rename_column t, :study_subject_id, :subject_id
		end

		add_index     :survey_invitations, [:survey_id, :subject_id], :unique => true
		[:response_sets].each do |t|
			add_index     t, :subject_id
		end
	end
end
