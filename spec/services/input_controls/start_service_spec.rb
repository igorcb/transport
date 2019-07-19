require 'rails_helper'

RSpec.describe InputControls::StartService, type: :service do
  context "Start" do
    before(:each) do
      #byebug
      @user = FactoryBot.create(:user)
      @input_control = FactoryBot.create(:input_control)
    end

    it "when input_controls and user is not exist" do
      result = InputControls::StartService.new(nil, nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Input Control is not exist.")
    end

    it "when input_controls and user exist" do
      @input_control.update_attributes(status: InputControl::TypeStatus::FINISH_TYPING)
      checkin = create_checkin_input(@input_control)
      result = InputControls::StartService.new(@input_control, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Input Control started successfully.")
    end

    it "when input_controls is not status FINISH_TYPING" do
      @input_control.update_attributes(status: InputControl::TypeStatus::OPEN)
      result = InputControls::StartService.new(@input_control, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Input Control does not have the status FINISH_TYPING.")
    end

    it "when input_controls is status FINISH_TYPING" do
      @input_control.update_attributes(status: InputControl::TypeStatus::FINISH_TYPING)
      checkin = create_checkin_input(@input_control)
      result = InputControls::StartService.new(@input_control, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Input Control started successfully.")
    end

    it "when the driver has not checkin" do
      Checkin.input_control.the_day.where(driver_cpf: @input_control.driver.cpf).destroy_all
      @input_control.update_attributes(status: InputControl::TypeStatus::FINISH_TYPING)
      result = InputControls::StartService.new(@input_control, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Driver has not checkin.")
    end

    it "when the driver checkin" do
      # byebug
      Checkin.the_day.where(driver_cpf: @input_control.driver.cpf).destroy_all
      @input_control.update_attributes(status: InputControl::TypeStatus::FINISH_TYPING)
      checkin = create_checkin_input(@input_control)
      result = InputControls::StartService.new(@input_control, @user).call
      expect(@input_control.reload.status).to equal(InputControl::TypeStatus::DISCHARGE)
      expect(Checkin.the_day.input_control.start.where(driver_cpf: @input_control.driver.cpf).present?).to be_truthy
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Input Control started successfully.")
    end

  end

  private
    def create_checkin_input(input_control)
      Checkin.create!( driver_cpf: input_control.driver.cpf,
                      driver_name: input_control.driver.nome.upcase,
                   operation_type: :input_control,
                     operation_id: input_control.id,
                      place_horse: 'HPX9087',
                     place_cart_1: 'PWM8765',
                     place_cart_2: 'LWK2981',
                             door: 1,
                           status: :input)
    end
end
