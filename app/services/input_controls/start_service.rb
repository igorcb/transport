module InputControls
  class StartService

    def initialize(input_control, user)
      @user = user
      @input_control = input_control
    end

    def call
      #byebug
      return {success: false, message: "Input Control is not exist."} if @input_control.nil? && @user.nil?
      return {success: false, message: "Input Control does not have the status FINISH_TYPING."} if @input_control.status != InputControl::TypeStatus::FINISH_TYPING
      return {success: false, message: "Driver has not checkin."} if !Checkin.the_day.input_control.input.where(driver_cpf: @input_control.driver.cpf).present?
      return {success: false, message: "Input Control already been started DISCHARGE.."} if Checkin.the_day.input_control.start.where(driver_cpf: @input_control.driver.cpf).present?

      begin
        # byebug
        checkin = Checkin.the_day.input_control.input.where(driver_cpf: @input_control.driver.cpf).first
        ActiveRecord::Base.transaction do
          Checkin.where(id: checkin.id).update_all(operation_id: @input_control.id)
          Checkin.create!(driver_cpf: @input_control.driver.cpf,
                         driver_name: @input_control.driver.nome.upcase,
                      operation_type: :input_control,
                        operation_id: @input_control.id,
                         place_horse: checkin.place_horse,
                        place_cart_1: checkin.place_cart_1,
                        place_cart_2: checkin.place_cart_2,
                                door: checkin.door,
                              status: :start)
          InputControl.where(id: @input_control.id).update_all(started_user_id: @user.id, start_time_discharge: Time.current, status: InputControl::TypeStatus::DISCHARGE)
          return {success: true, message: "Input Control started successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private
  end
end
