module InputControls
  class StartService

    def initialize(input_control, user)
      @user = user
      @input_control = input_control
    end

    def call
      #byebug
      return {success: false, message: "Input Control is not exist."} if @input_control.nil? && @user.nil?
      # return {success: false, message: "Input Control does not have the status DISCHARGE."} if @input_control.status != InputControl::TypeStatus::FINISH_TYPING
      # return {success: false, message: "Driver has not checkin."} if !Checkin.the_day.input_control.input.where(driver_cpf: @input_control.driver.cpf).present?
      # return {success: false, message: "Input Control already been FINALIZED."} if Checkin.the_day.input_control.finish.where(driver_cpf: @input_control.driver.cpf).present?

      begin
        # byebug
        checkin = Checkin.the_day.input_control.input.where(driver_cpf: @input_control.driver.cpf).first
        ActiveRecord::Base.transaction do

          return {success: true, message: "Input Control finish successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private
  end
end
