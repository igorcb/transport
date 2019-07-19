module InputControls
  class FinishService

    def initialize(input_control, user)
      @user = user
      @input_control = input_control
    end

    def call
      #byebug
      return {success: false, message: "Input Control is not exist."} if @input_control.nil? && @user.nil?
      return {success: false, message: "Input Control does not have the status DISCHARGE."} if @input_control.status != InputControl::TypeStatus::DISCHARGE
      return {success: false, message: "Checkin does not have as START"} if !Checkin.the_day.input_control.start.where(driver_cpf: @input_control.driver.cpf).present?
      return {success: false, message: "Input Control already been FINALIZED."} if Checkin.the_day.input_control.finish.where(driver_cpf: @input_control.driver.cpf).present?

      begin
        #byebug
        checkin = Checkin.the_day.input_control.start.where(driver_cpf: @input_control.driver.cpf).first
        ActiveRecord::Base.transaction do
          nfe_input_control = @input_control.nfe_xmls.first
          nfe_scheduling = NfeXml.where(nfe_type: "Scheduling", numero: nfe_input_control.numero).first
          Scheduling.where(id: nfe_scheduling.nfe_id).update_all(date_receipt_at: Time.current, status: Scheduling::TypeStatus::RECEIVED) if nfe_scheduling.present?
          Checkin.create!( driver_cpf: @input_control.driver.cpf,
                          driver_name: @input_control.driver.nome.upcase,
                       operation_type: :input_control,
                         operation_id: @input_control.id,
                          place_horse: checkin.place_horse,
                         place_cart_1: checkin.place_cart_1,
                         place_cart_2: checkin.place_cart_2,
                                 door: checkin.door,
                               status: :finish)
          InputControl.where(id: @input_control.id).update_all(date_receipt: Date.current, received_user_id: @user.id, finish_time_discharge: Time.current, status: InputControl::TypeStatus::RECEIVED)
          return {success: true, message: "Input Control finish successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private
  end
end
