class Comment < ActiveRecord::Base
  belongs_to :ordem_service, polymorphic: true, dependent: :destroy
end
