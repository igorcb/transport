class UsersTasks < ApplicationRecord
  validates :user_id, presence: true, required: false
  validates :task_id, presence: true, required: false
end
