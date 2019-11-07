module InputControlsHelper

  def select_status_input_control
    ([["Aberto", 0],["Recebido", 1], ["Fechado", 2], ["Faturado", 3], ["Dig.Finalizada",4], ["Descarregando",5]])
  end

  def select_equipamento
    ([["NOTA_FISCAL", 0],["PALETE", 1], ["CINTA", 2], ["CHAPATEX", 3]])
  end

  def select_team #ver final do arquivo
    ([["IMBATIVEIS", 1],["UNIDOS VENCEREMOS", 2], ["DIARISTA", 3]])
  end

  def select_dock
    ([["1", 1],["2", 2], ["3", 3], ["4", 4], ["5", 5], ["6", 6], ["7", 7]])
  end

  def select_hangar
    ([["1", 1],["2", 2],["3", 3]])
  end

  def link_to_ordem_service(number, chave)
		nfe_key = NfeKey.where(nfe_type: 'OrdemService', chave: chave)
		if nfe_key.present?
      link_to number, nfe_key.first.ordem_service
		else
			number
		end
  end

  def get_chave(id)
    nfe_xml = NfeXml.where(id: id)
    if nfe_xml.first.chave.present?
      nfe_xml.first.chave
    else
      nfe_xml.first.asset_file_name
    end
  end

  def calculation_discharge(value)
    value = 0.00 # if value.nil?
    value_discharge = ConfigSystem.where(config_key: 'VALUE_DISCHARGE_OPERATION').first
    calc = value * (value_discharge.config_value.to_f / 1000)
    number_to_currency(calc, precision: 2, unit: "R$ ", separator: ",", delimiter: ".")
  end

  def input_stretch_route(client_id)
    #client = Client.where(cpf_cnpj: params[:cpf_cnpj]).first
    client = Client.where(id: client_id).first
    StretchRoute.where(id: client.client_table_prices.select(:stretch_route_id).uniq.pluck(:stretch_route_id))
  end

  def input_type_service(client_id, stretch_route_id )
    #StretchRoute.where(id: client.client_table_prices.select(:stretch_route_id).uniq.pluck(:stretch_route_id))
    type_service_ids = ClientTablePrice.select(:type_service_id).where(client_id: client_id, stretch_route_id: stretch_route_id).pluck(:type_service_id)
    TypeService.where(id: type_service_ids)
  end

  def input_items_button(input_control)

    return link_to 'Iniciar Recebimento', start_input_control_path(input_control), class: "btn btn-blue btn-xs" if input_control.status == InputControl::TypeStatus::FINISH_TYPING

    if input_control.status == InputControl::TypeStatus::DISCHARGE
      return link_to 'Iniciar Conferencia', start_conference_input_control_path(input_control), class: "btn btn-blue btn-xs" if input_control.conferences.count < 2
    end

    #when status was conference
    if current_user.has_role? :oper
      if input_control.status == InputControl::TypeStatus::CONFERENCE
        if input_control.conferences.last.status == "start"
          return link_to 'Items da Conferencia', items_input_control_path(input_control), class: "btn btn-blue btn-xs" if input_control.conferences.count == 1
          return link_to 'Revisar', review_conference_input_control_path(input_control), class: "btn btn-warning btn-xs" if input_control.conferences.count == 2
        else
          # test when approved
          if input_control.conferences.last.approved == "waiting"
            return  "<span class=\"text-danger\">Aguardando supervisor</span>".html_safe
          elsif input_control.conferences.last.approved == "yes"
            if input_control.avaria.nil?
              return link_to 'Tem avaria?', has_avaria_input_control_path(input_control), class: "btn btn-blue btn-xs"
            elsif input_control.avaria
              if input_control.date_finish_avaria.nil?
                conference = input_control.conferences.order(id: :asc).last
                return link_to 'Informar Avaria', input_control_conference_conference_breakdowns_path(input_control, conference), class: "btn btn-blue btn-xs"
              else
                return link_to 'Confirmar Recebimento', received_input_control_path(input_control), class: "btn btn-blue btn-xs"
              end
            else
              return link_to 'Confirmar Recebimento', received_input_control_path(input_control), class: "btn btn-blue btn-xs"
            end
          else
            return link_to 'Iniciar Conferencia', start_conference_input_control_path(input_control), class: "btn btn-blue btn-xs" if input_control.conferences.count < 2
            return "<span class=\"text-danger\">Aguardando supervisor</span>".html_safe if input_control.conferences.count >= 2
          end
        end
      end
    end
  end


end

  # Fazer testes com esses helper
  #options_for_select([ "VISA", "MasterCard", "Discover" ], ["VISA", "Discover"])
  #options_for_select([ "Denmark", ["USA", {class: 'bold'}], "Sweden" ], ["USA", "Sweden"])
  #options_for_select([["Dollar", "$", {class: "bold"}], ["Kroner", "DKK", {onclick: "alert('HI');"}]])
  #options_for_select(["Free", "Basic", "Advanced", "Super Platinum"], disabled: "Super Platinum")
  #options_for_select(["Free", "Basic", "Advanced", "Super Platinum"], disabled: ["Advanced", "Super Platinum"])
  #options_for_select(["Free", "Basic", "Advanced", "Super Platinum"], selected: "Free", disabled: "Super Platinum")
