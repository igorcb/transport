class Link < ActiveRecord::Base
	belongs_to :user
	include RankedModel
  ranks :row_order
end
