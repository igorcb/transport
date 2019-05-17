module Boardings
  class AddPaymentDischargeService

    def initialize(boarding, user)
      @boarding = boarding
      @user = user
    end

    def call
      #byebug
      return {success: false, message: "Boarding, please inform the driver."} if @boarding.driver_id.to_i == Boarding.driver_not_information.to_i
      return {success: false, message: "Boarding, please inform the carrier."} if @boarding.carrier_id.to_i == Boarding.carrier_not_information.to_i
      return {success: false, message: "Boarding, please inform the date boarding."} if @boarding.date_boarding.nil?
      return {success: false, message: "Boarding, not have O.S."} if !@boarding.boarding_items.present?
      #if !check_all_ordem_service_have_payment_discharge?
        return {success: false, message: "Boarding, please inform discharge payment all O.S."} if !check_all_ordem_service_have_payment_discharge?
      #end

      begin
        ActiveRecord::Base.transaction do
          @boarding.account_payables.build
          @account_payable = @boarding.account_payables.build
          @account_payable.type_account = AccountPayable::TypeAccount::DRIVER
          @account_payable.supplier_type = "Driver"
          @account_payable.supplier_id = @boarding.driver_id
          @account_payable.cost_center_id = ConfigSystem.where(config_key: 'PAYMENT_DISCHARGE_COST_CENTER').first.config_value
          @account_payable.sub_cost_center_id = ConfigSystem.where(config_key: 'PAYMENT_DISCHARGE_SUB_COST_CENTER').first.config_value
          @account_payable.sub_cost_center_three_id = ConfigSystem.where(config_key: 'PAYMENT_DISCHARGE_SUB_COST_CENTER_THREE').first.config_value
          @account_payable.payment_method_id = ConfigSystem.where(config_key: 'PAYMENT_METHOD_DEFAULT').first.config_value
          @account_payable.historic_id = ConfigSystem.where(config_key: 'HISTORIC_DEFAULT').first.config_value
          @account_payable.data_vencimento = Date.today
          @account_payable.documento = "#{@boarding.id}"
          @account_payable.valor = @boarding.total_discharge_payment
          #@account_payable.observacao = "PAGAMENTO DE DESCARGA O.S No: #{@boarding.ordem_services_ids}, "
          @account_payable.observacao = @boarding.observation_discharge_payment
          @account_payable.user_created_id = @user.id
          @account_payable.status = AccountPayable::TipoStatus::ABERTO
          @account_payable.save!
          return {success: true, message: "Boarding, payment discharge created successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private
      def check_all_ordem_service_have_payment_discharge?
        positivo = true
        @boarding.boarding_items.each do |item|
          #byebug
          positivo = item.ordem_service.discharge_payments.present?
          if positivo == false
            return false
          end
        end
        positivo
      end
  end
end
