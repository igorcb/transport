class ItemInputControl < ActiveRecord::Base
  belongs_to :input_control, required: true
  belongs_to :product, required: true
  validates :number_nfe, presence: true

  def qtde_pallets
    result = qtde.divmod(product.box_by_pallet)
    pallets = (result[1].to_f > 0.0) ? result[0] + 1 : result[0]
    pallets.to_f.round
  end
end
