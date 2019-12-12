#encoding: utf-8
class PalletizingPalletsController < ApplicationController
  before_action :set_palletizing
  def index
    @pallets = @palletizing.palletizing_pallets
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
          breakdown = @input_control.breakdown_nfe_xmls.where(nfe_xml_id: nfe, product_id: product.id).first
          avarias = breakdown.avarias.to_i if breakdown.present?
          faltas = breakdown.faltas.to_i if breakdown.present?
          qtde = item.qtde.to_i - avarias.to_i - faltas.to_i
          suggested_pallet = NfeXmls::CalcItemNfeQtdePalletService.new(product, qtde).call
          data[index][:items].push({item_id: item.id, cod_prod: product.cod_prod, product_description: product.descricao, qtde: qtde, suggested_pallet: suggested_pallet[:qtde_pallet]})
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
