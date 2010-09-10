class Guide < ActiveRecord::Base
	default_scope :order => 'controller ASC, action ASC'
	validates_uniqueness_of :action, :scope => :controller
end
