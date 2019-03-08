module ProductCreateOrUpdate
  extend ActiveSupport::Concern

  module ClassMethods
  #included do
    def product_create_or_update_xml(nfe_xml, nfe)
      nfe.prod.each do |product|
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

        add_item_input_controls(nfe_xml, produto, prod) if nfe_xml.input_control.present?
      end
    end

    private
      def add_item_input_controls(nfe_xml, product, prod)
        puts ">>>>>>>>>>> #{nfe_xml.to_json}"
        item = nfe_xml.item_input_controls.create!(
                                        input_control_id: nfe_xml.nfe_id,
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
