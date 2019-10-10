module Conferences
  class ApproveConferenceWithDivergenceService

    def initialize(input_control)
      @input_control = input_control
    end

    def call
      #byebug
      return {success: false, message: "InputControl is not found."} if !@input_control.present?
      #@item_input_controls = @input_control.item_input_controls.select(:product_id).group(:product_id).sum(:qtde)
      @item_input_controls = @input_control.items_only_equipament_nfe
      @conference = @input_control.conferences.last
      @conference_items = @conference.conference_items

      begin
        # byebug
        ActiveRecord::Base.transaction do
          @divergencias = []
          if @item_input_controls.count < @conference_items.count
            @conference_items.each do |conference_item|
              qtde_nfe = @item_input_controls[conference_item.product_id].nil? ? 0 : @item_input_controls[conference_item.product_id]
              qtde_oper = conference_item.qtde_oper
              item_input_control  = @input_control.item_input_controls.where(product_id: conference_item.product_id).first
              number_nfe = item_input_control.nil? ? nil : item_input_control.number_nfe

              if qtde_nfe < qtde_oper
                sobra = qtde_oper - qtde_nfe
                @divergencias.push({nfe_xml_id: number_nfe, product_id: conference_item.product_id,  sobras: sobra, type_breakdown: 1, unid_medida: "CX"})
              elsif qtde_nfe > qtde_oper
                falta = qtde_nfe - qtde_oper
                @divergencias.push({nfe_xml_id: number_nfe, product_id: conference_item.product_id,  faltas: falta, type_breakdown: 1, unid_medida: "CX"})
              end
            end
          else
            @item_input_controls.each do |item_input_control|
              qtde_nfe = item_input_control[1]
              item = @conference_items.where(product_id: item_input_control[0]).first
              item = item.nil? ? 0 : item
              item_input  = @input_control.item_input_controls.where(product_id: item_input_control[0]).first
              number_nfe = item_input.nil? ? nil : item_input.number_nfe

              if qtde_nfe < item.qtde_oper
                sobra = item.qtde_oper - qtde_nfe
                @divergencias.push({nfe_xml_id: number_nfe, product_id: conference_item.product_id,  sobras: sobra, type_breakdown: 1, unid_medida: "CX"})
              elsif qtde_nfe > item.qtde_oper
                falta = qtde_nfe - item.qtde_oper
                @divergencias.push({nfe_xml_id: number_nfe, product_id: conference_item.product_id,  faltas: falta, type_breakdown: 1, unid_medida: "CX"})
              end
            end
          end
          @divergencias.each do |divergencia|
            #@input_control.breakdowns.create!(divergencia)
            Breakdown.where(breakdown_type: "InputControl", breakdown_id: @input_control, product_id: divergencia[:product_id] ).update_or_create(divergencia)
          end
          @conference.update_attributes(approved: :yes, status: :finish)
          #@input_control.update_attributes(status: InputControl::TipoStatus::)
        end
        return {success: true, message: "Breakdown on input_control created successfully."}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end

end
