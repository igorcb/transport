class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles, required: false
  belongs_to :resource, :polymorphic => true, required: false
  validates :name, presence: true, uniqueness: true

  scopify
end
