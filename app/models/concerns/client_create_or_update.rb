module ClientCreateOrUpdate
  extend ActiveSupport::Concern

  #module ClassMethods
  included do
    def self.client_create_or_update_xml(type_client, nfe)
      #TypeClient: source or target
      client = (type_client == 'source') ? source_client(nfe) : target_client(nfe)
    end

    private
      def source_client(nfe)
        cnpj_source = nfe.emit.CNPJ.nil? ? nfe.emit.CPF.to_s : nfe.emit.CNPJ.to_s
        if cnpj_source.length == 11
          tipo_pessoa = 0
          cnpj_source.insert(3, '.').insert(7, '.').insert(11, '-')
        else
          tipo_pessoa = 1
          cnpj_source.insert(2, '.').insert(6, '.').insert(10, '/').insert(15, '-')
        end
        #Location Source Client ou Create ou Update
        source_client = Client.create_with(
                                        tipo_cliente: Client::TipoCliente::NORMAL,
                                        tipo_pessoa: tipo_pessoa,
                                    group_client_id: 7,
                                               nome: nfe.emit.xNome,
                                           fantasia: nfe.emit.xNome,
                                                cep: nfe.emit.endereco_emitente.CEP,
                                           endereco: nfe.emit.endereco_emitente.xLgr,
                                             numero: nfe.emit.endereco_emitente.nro,
                                        complemento: nfe.emit.endereco_emitente.xCpl,
                                             bairro: nfe.emit.endereco_emitente.xBairro,
                                             cidade: nfe.emit.endereco_emitente.xMun,
                                             estado: nfe.emit.endereco_emitente.UF).find_or_create_by(cpf_cnpj: cnpj_source)

      end

      def target_client(nfe)
        cnpj_target = nfe.dest.CNPJ.nil? ? nfe.dest.CPF.to_s : nfe.dest.CNPJ.to_s
        if cnpj_target.length == 11
          tipo_pessoa = 0
          cnpj_target.insert(3, '.').insert(7, '.').insert(11, '-')
        else
          tipo_pessoa = 1
          cnpj_target.insert(2, '.').insert(6, '.').insert(10, '/').insert(15, '-')
        end
        #Location Source Client ou Create ou Update
        target_client = Client.find_or_create_by!(cpf_cnpj: cnpj_target) do |client|
          client.tipo_cliente = Client::TipoCliente::NORMAL
          client.tipo_pessoa = 1
          client.group_client_id = 7
          client.nome        = nfe.dest.xNome
          client.fantasia    = nfe.dest.xNome
          client.cep         = nfe.dest.endereco_destinatario.CEP.blank? ? "00000-000" : nfe.dest.endereco_destinatario.CEP
          client.endereco    = nfe.dest.endereco_destinatario.xLgr
          client.numero      = nfe.dest.endereco_destinatario.nro
          client.complemento = nfe.dest.endereco_destinatario.xCpl
          client.bairro      = nfe.dest.endereco_destinatario.xBairro
          client.cidade      = nfe.dest.endereco_destinatario.xMun
          client.estado      = nfe.dest.endereco_destinatario.UF
        end
      end
  end
end
