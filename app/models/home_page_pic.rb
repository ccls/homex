class HomePagePic < ActiveRecord::Base
	validates_presence_of :title
	has_attached_file :image, :styles => {
		:full   => "900",
		:medium => "600",
		:small  => "150x50>"
	}
end
