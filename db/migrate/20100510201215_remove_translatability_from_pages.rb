class RemoveTranslatabilityFromPages < ActiveRecord::Migration
	def self.up
		remove_index  :pages, [:path,:locale]
		remove_index  :pages, [:menu_en,:locale]
		remove_index  :pages, [:translatable_id, :locale]
		remove_column :pages, :translatable_id
		remove_column :pages, :locale
		add_index :pages, :path,    :unique => true, :name => 'by_path'
		add_index :pages, :menu_en, :unique => true, :name => 'by_menu'
	end

	def self.down
		remove_index :pages, :name => 'by_path'
		remove_index :pages, :name => 'by_menu'
		add_column :pages, :locale, :string, :default => 'en', :null => false
		add_column :pages, :translatable_id, :integer

		add_index  :pages, [:translatable_id, :locale], :unique => true
		add_index :pages, [:menu_en,:locale], :unique => true
		add_index :pages, [:path,:locale], :unique => true
		Page.all.each do |p|
			p.update_attribute(:translatable_id, p.id)
		end
	end
end
