class OrdemServiceChange < ActiveRecord::Base
  belongs_to :ordem_service
  belongs_to :driver
end
