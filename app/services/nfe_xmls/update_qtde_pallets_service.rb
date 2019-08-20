module NfeXmls
  class UpdateQtdePalletsService

    def initialize(nfe_xml, qtde_pallet)
      @nfe_xml = nfe_xml
      @qtde_pallet = qtde_pallet
    end

    def call
      return {success: false, message: "NF-e XML is not exist."} if @nfe_xml.blank?
      return {success: false, message: "Qtde Pallets is not present."} if @qtde_pallet.blank?
      return {success: false, message: "Qtde Pallets must be greater than 0 (zero)."} if @qtde_pallet.to_i < 1

      begin
        ActiveRecord::Base.transaction do
          NfeXml.where(id: @nfe_xml.id).update_all(qtde_pallet: @qtde_pallet)
          ordem_service = @nfe_xml.ordem_service('input_controls')
          NfeKey.where(nfe: @nfe_xml.numero, nfe_type: 'OrdemService', nfe_id: ordem_service.id).update_all(qtde_pallet: @qtde_pallet) if ordem_service.present?

          return {success: true, message: "Qtde de Pallet information successfully."}
        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end
    end
  end
end
