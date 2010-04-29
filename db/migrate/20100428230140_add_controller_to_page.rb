class AddControllerToPage < ActiveRecord::Migration
	def self.up
		add_column :pages, :controller, :string
		#	can't be unique as most are "" (not NULL)
		add_index  :pages, :controller	#, :unique => true
	end

	def self.down
		remove_column :pages, :controller
		remove_index  :pages, :controller
	end
end
