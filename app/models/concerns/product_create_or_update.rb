module ProductCreateOrUpdate
  extend ActiveSupport::Concern

  class_methods do
    #type_create_ordem_service: directcharge or inputcontrol
    #NfeXml.product_create_or_update_xml(nfe_xml.input_control, nfe_xml, nfe)
    def product_create_or_update_xml(type_create_ordem_service, nfe_type, nfe_xml, nfe)
      nfe.prod.each do |product|
        #byebug
        prod = Produto.new
        prod.attributes=(product)
        produto = Product.create_with(category_id: 6,
                                  cubagem: 0,
                                 cod_prod: prod.cProd,
                                descricao: prod.xProd,
                                      ean: prod.cEAN,
                                 ean_trib: prod.cEANTrib,
                                      ncm: prod.NCM,
                                     cfop: prod.CFOP,
                              unid_medida: prod.uCom,
                           valor_unitario: prod.vUnTrib).find_or_create_by(cod_prod: prod.cProd)
        produto.save!
        if type_create_ordem_service == 'direct_charges'
          add_item_direct_charges(nfe_type, nfe_xml, produto, prod)
        else
          add_item_input_controls(nfe_type, nfe_xml, produto, prod)
        end
      end
    end

    private
      def add_item_input_controls(input_control, nfe_xml, product, prod)
        result = NfeXmls::CalcItemNfeQtdePalletService.new(product, prod.qCom.to_f).call
        qtde_pallets = result[:success] ? result[:qtde_pallet] : 0.00
        item = nfe_xml.item_input_controls.create!(
                                        input_control_id: input_control.id,
                                              number_nfe: nfe_xml.numero,
                                              product_id: product.id,
                                                    qtde: prod.qCom,
                                               qtde_trib: prod.qTrib,
                                                   valor: prod.vProd,
                                          valor_unitario: prod.vUnTrib,
                                    valor_unitario_comer: prod.vUnCom,
                                             unid_medida: prod.uCom,
                                             qtde_pallet: qtde_pallets
                                      )

      end
      def add_item_direct_charges(direct_charge, nfe_xml, product, prod)
        item = nfe_xml.item_direct_charges.create!(
                                        direct_charge_id: direct_charge.id,
                                              number_nfe: nfe_xml.numero,
                                              product_id: product.id,
                                                    qtde: prod.qCom,
                                               qtde_trib: prod.qTrib,
                                                   valor: prod.vProd,
                                          valor_unitario: prod.vUnTrib,
                                    valor_unitario_comer: prod.vUnCom,
                                             unid_medida: prod.uCom
                                      )

      end
  end
end
