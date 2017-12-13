class Company < ActiveRecord::Base
	validates :image, :attachment_presence => true
	validates :quitter, :attachment_presence => true
 #  validates_attachment :image, :presence => true,
 #  										 :content_type => { :content_type => "image/jpg" },
 #  										 :size => { :in => 0..100.kilobytes }	
	has_attached_file :image, styles: { small: "64x64", med: "100x100", large: "200x200" }
	has_attached_file :quitter, styles: { small: "64x64", med: "100x100", large: "200x200" }


	def cidade_estado
    "#{self.cidade} '-' #{self.estado}"
	end
	
end
