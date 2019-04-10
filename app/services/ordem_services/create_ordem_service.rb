module OrdemServices
  class CreateOrdemService
    #params = type_create_ordem_service, id, id_nfes
    def initialize(params = {}) #directcharge or inputcontrol
      #byebug
      # case type_os.downcase
  		# when 'direct_charges' then nfe_key = NfeKey.where(nfe_source_type: 'DirectCharge', nfe_type: 'OrdemService', nfe: self.numero, chave: self.chave)
  		# when 'input_controls' then nfe_key = NfeKey.where(nfe_source_type: 'InputControl', nfe_type: 'OrdemService', nfe: self.numero, chave: self.chave)
      # end
      @ordem_service_type = params[:type_create_ordem_service]
      if @ordem_service_type == 'direct_charges'
        @input_control = DirectCharge.find(params[:id])
      else
        @input_control = InputControl.find(params[:id])
      end
      #{}"nfe"=>{"ids"=>{"44"=>"44"}}
      @ids_nfes = params[:ids_nfe] # NfeXml.where(id: 44)
    end

    def call
      #fazer validação dos parametros
      #retornar com mes
      ActiveRecord::Base.transaction do
        nfe_xmls = @input_control.nfe_xmls.nfe.not_create_os.where(id: @ids_nfes)
        total_weight = @input_control.nfe_xmls.nfe.sum(:peso).to_f
        total_weight_nfe_select = @input_control.nfe_xmls.nfe.not_create_os.where(id: @ids_nfes).sum(:peso)

        target_client = nfe_xmls.first.target_client
        source_client = nfe_xmls.first.source_client
        #billing_client = @input_control.billing_client
        #carrier = @input_control.carrier

        nfe_scheduling = NfeXml.where(nfe_type: "Scheduling", numero: nfe_xmls.first.numero).first

        @data_scheduling = nil
        if nfe_scheduling.present?
          data_scheduling = nfe_scheduling.scheduling.date_scheduling_client.present? ? nfe_scheduling.scheduling.date_scheduling_client : nil
        end

        if @input_control.client_table_price.present?
          value_weight_average = input_control.client_table_price.minimum_total_freight / total_weight
          value_freight_select = total_weight_nfe_select * value_weight_average
        end
        #byebug
        if @ordem_service_type == 'direct_charges'
          ordem_service = create_ordem_service_direct_charge(source_client, target_client)
        else
          ordem_service = create_ordem_service_input_control(source_client, target_client)
        end
        #puts ">>>>>>>>>>>>>>>> Criar Ordem de Servico Logistica"
        ordem_service.ordem_service_logistics.create!(driver_id: @input_control.driver.id,
                                                          placa: @input_control.place,
                                                           peso: @input_control.weight,
                                                    qtde_volume: @input_control.volume)

       #puts ">>>>>>>>>>>>>>>> Importar dados da NFE XML para NFE Keys"
       nfe_xmls.each do |nfe|
           ordem_service.nfe_keys.create!(nfe: nfe.numero,
                                       chave: nfe.chave,
                                      nfe_id: ordem_service.id,
                                    nfe_type: "OrdemService",
                             nfe_source_type: nfe.nfe_type,
                                 remessa_ype: @input_control.shipment,
                                        peso: nfe.peso,
                                     average: value_weight_average,
                                      volume: nfe.volume
                                       )

         #puts ">>>>>>>>>>>>>>>> Importar produtos"
         nfe.item_input_controls.each do |item|
           ordem_service.item_ordem_services.create!( product_id: item.product_id,
                                                          number: item.number_nfe,
                                                            qtde: item.qtde_trib,
                                                           valor: item.valor,
                                                     unid_medida: item.unid_medida,
                                                  valor_unitario: item.valor_unitario,
                                            valor_unitario_comer: item.valor_unitario_comer
                                       )
           #puts ">>>>>>>>>>>>>>>>> se nota de palete lançar no controle de palete"

         end

         NfeXml.where(id: nfe.id).update_all(create_os: NfeXml::TipoOsCriada::SIM)
       end


        return {success: true, message: "Ordem Service was successfully created. " }
      end

      rescue Exception => exception
        return {success: false, error: "#{exception.message} "}
    end

    private
      def ge
        #code
      end
      def create_ordem_service_input_control(source_client, target_client)
        ordem_service = OrdemService.create!( tipo: OrdemService::TipoOS::LOGISTICA,
                                ordem_service_type: 'type_input_control',
                                  input_control_id: @input_control.id,
                                  target_client_id: target_client.id,
                                  source_client_id: source_client.id,
                             #     billing_client_id: billing_client.id,
                             # client_table_price_id: billing_client.client_table_price_reset.id,
                                        carrier_id: Carrier.carrier_default,
                                  carrier_entry_id: @input_control.carrier.id,
                                              peso: @input_control.weight,
                                       qtde_volume: @input_control.volume,
                                            estado: target_client.estado,
                                            cidade: target_client.cidade,
                                        date_entry: @input_control.date_receipt,
                                              data: @data_scheduling,
                                        observacao: ""
                                                   )
      end

      def create_ordem_service_direct_charge(source_client, target_client)
        OrdemService.create!( tipo: OrdemService::TipoOS::LOGISTICA,
                                ordem_service_type: 'type_direct_charge',
                                  direct_charge_id: @input_control.id,
                                  target_client_id: target_client.id,
                                  source_client_id: source_client.id,
                                 billing_client_id: @input_control.billing_client.id,
                                        carrier_id: Carrier.carrier_default,
                                  carrier_entry_id: @input_control.carrier.id,
                                              peso: @input_control.weight,
                                       qtde_volume: @input_control.volume,
                                            estado: target_client.estado,
                                            cidade: target_client.cidade,
                                        date_entry: @input_control.date_charge,
                                        observacao: ""
                                                   )
      end
  end
end
