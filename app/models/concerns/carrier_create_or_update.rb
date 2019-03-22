require 'active_support/concern'
module CarrierCreateOrUpdate
  extend ActiveSupport::Concern

  class_methods do
    def carrier_create_or_update_xml(nfe)
      cnpj_carrier = ''
      cnpj_carrier = nfe.transp.CNPJ.nil? ? nfe.transp.CPF.to_s : nfe.transp.CNPJ.to_s
      cnpj_carrier.insert(2, '.').insert(6, '.').insert(10, '/').insert(15, '-')
      carrier = Carrier.create_with(cnpj: cnpj_carrier,
                                    nome: nfe.transp.xNome,
                                fantasia: nfe.transp.xNome,
                      inscricao_estadual: nfe.transp.IE,
                     inscricao_municipal: "s/n",
                                     cep: "s/n",
                                endereco: nfe.transp.xEnder,
                                  numero: "s/n",
                             complemento: nil,
                                  bairro: "s/n",
                                  cidade: nfe.transp.xMun,
                                  estado: nfe.transp.UF).find_or_create_by(cnpj: cnpj_carrier)
      carrier
    end

  end
end
