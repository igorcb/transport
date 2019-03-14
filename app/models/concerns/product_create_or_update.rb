module ProductCreateOrUpdate
  extend ActiveSupport::Concern

  class_methods do
    def product_create_or_update_xml(input_control, nfe_xml, nfe)
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
        add_item_input_controls(input_control, nfe_xml, produto, prod) # if input_control.present?
      end
    end

    private
      def add_item_input_controls(input_control, nfe_xml, product, prod)
        #byebug
        #puts ">>>>>>>>>>>>>>>>>>>> AdditemInputControls: #{nfe_xml.class} - #{nfe_xml.id}, Product: #{product.id}, Prod: #{prod.cProd} "
        #puts ">>>>>>>>>>>>>>>>>>>> AdditemInputControls: #{count}"
        item = nfe_xml.item_input_controls.create!(
                                        input_control_id: input_control.id,
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
