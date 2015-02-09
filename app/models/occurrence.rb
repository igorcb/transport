class Occurrence < ActiveRecord::Base
  validates :driver_id, presence: true
  validates :placa, presence: true, length: { maximum: 10 }
  validates :cte, presence:true
  
  belongs_to :driver

  has_many :nfe_keys, class_name: "NfeKey", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_keys, allow_destroy: true, :reject_if => :all_blank

  has_many :comments, class_name: "Comment", foreign_key: "comment_id", :as => :comment, dependent: :destroy
  has_many :commentaries, class_name: "Comment", foreign_key: "comment_id", :as => :comment, dependent: :destroy

  def feed
    Comment.where("comment_type = ? and comment_id = ?", "Occurrence", self.id)
  end

end
