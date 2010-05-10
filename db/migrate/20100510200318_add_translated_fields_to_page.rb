class AddTranslatedFieldsToPage < ActiveRecord::Migration
	def self.up
		change_table :pages do |t|
			t.rename :title, :title_en
			t.rename :menu,  :menu_en
			t.rename :body,  :body_en
			t.string :title_es
			t.string :menu_es
			t.text   :body_es
		end
	end

	def self.down
		change_table :pages do |t|
			t.rename :title_en, :title
			t.rename :menu_en,  :menu
			t.rename :body_en,  :body
			t.remove :title_es
			t.remove :menu_es
			t.remove :body_es
		end
	end
end
