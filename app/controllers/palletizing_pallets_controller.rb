#encoding: utf-8
class PalletizingPalletsController < ApplicationController
  before_action :set_palletizing
  def index
    @pallets = @palletizing.palletizing_pallet
  end

  def new
    @pallet = Pallet.new
    view_mode = @palletizing.view_mode
    if view_mode == "by_customer"
      nfes = @input_control.nfe_xmls
      data = []
      nfes.each_with_index do |nfe, index|
        data[index] = {group_name: nfe.numero.to_i, items: []}
        nfe.item_input_controls.each do |item|
          product = item.product
          data[index][:items].push({item_id: item.id, product: "#{product.cod_prod} #{product.descricao}", qtde: item.qtde.to_i})
        end
      end
    end
    @items = data.to_json.html_safe
  end

  def create
  end

  def delete
  end

  private
  def set_palletizing
    @palletizing = Palletizing.where(id: params[:palletizing_id]).first
    @input_control = @palletizing.input_control
  end
end
