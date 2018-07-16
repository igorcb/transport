class MicroRegionsCity < ActiveRecord::Base
  #has_and_belongs_to_many :users, :join_table => :users_roles
  has_and_belongs_to_many :cities, :join_table => :cities
  has_and_belongs_to_many :micro_regions, :join_table => :micro_regions

  #belongs_to :micro_region
  belongs_to :city

  validates :city_id, presence: true
end


# class Role < ActiveRecord::Base
#   has_and_belongs_to_many :users, :join_table => :users_roles
#   belongs_to :resource, :polymorphic => true
#   validates :name, presence: true, uniqueness: true
  
#   scopify
# end
