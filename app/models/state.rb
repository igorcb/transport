class State < ActiveRecord::Base
  belongs_to :region, required: false
end
