class Event < ActiveRecord::Base
  belongs_to :user, required: false
end
