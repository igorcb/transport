module PalletizingPalletsHelper

  def feedback_palletizing_pallet(ean)
    product = Product.where("cod_prod = ? or ean_box = ?", ean, ean).first
    # return product.inspect
    if ean.present? && product.nil?
      return {success: false, message: "Este produto não está cadastrado.",  css: "has-error"}
    elsif ean.nil?
      return {success: true, message: "Digite um produto",  css: ""}
    elsif ean.present? && product.present?
      return {success: true, message: "",  css: "has-success"}
    end
  end
end
