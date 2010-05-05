class AddTranslatabilityToPages < ActiveRecord::Migration
	def self.up
		add_column :pages, 
			:translatable_id, :integer
		add_column :pages, 
			:locale, :string, :default => 'en', :null => false
		add_index  :pages, 
			[:translatable_id, :locale], :unique => true
		Page.all.each do |p|
			p.update_attribute(:translatable_id, p.id)
		end
	end

	def self.down
		remove_index  :pages, 
			[:translatable_id, :locale]
		remove_column :pages, 
			:translatable_id
		remove_column :pages, 
			:locale
	end
end
