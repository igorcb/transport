require 'rails_helper'

RSpec.describe InputControls::FinishService, type: :service do
  context "Finish" do
    before(:each) do
      #byebug
      @user = FactoryBot.create(:user)
      @input_control = FactoryBot.create(:input_control)
      NfeXml.first.update_attributes(nfe_id: @input_control.id)
    end

    it "when input_controls and user is not exist" do
      result = InputControls::FinishService.new(nil, nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Input Control is not exist.")
    end

    it "when input_controls and user exist" do
      Checkin.input_control.the_day.where(driver_cpf: @input_control.driver.cpf).destroy_all
      @input_control.update_attributes(status: InputControl::TypeStatus::DISCHARGE)
      checkin = create_checkin_input(@input_control)
      checkin = create_checkin_start(@input_control)
      result = InputControls::FinishService.new(@input_control, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Input Control finish successfully.")
    end

    it "when input_controls is not status DISCHARGE" do
      Checkin.input_control.the_day.where(driver_cpf: @input_control.driver.cpf).destroy_all
      @input_control.update_attributes(status: InputControl::TypeStatus::OPEN)
      result = InputControls::FinishService.new(@input_control, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Input Control does not have the status DISCHARGE.")
    end

    it "when input_controls is status DISCHARGE" do
      Checkin.input_control.the_day.where(driver_cpf: @input_control.driver.cpf).destroy_all
      @input_control.update_attributes(status: InputControl::TypeStatus::DISCHARGE)
      checkin = create_checkin_input(@input_control)
      checkin = create_checkin_start(@input_control)
      result = InputControls::FinishService.new(@input_control, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Input Control finish successfully.")
    end

    it "when checkin does not have as START" do
      Checkin.input_control.the_day.where(driver_cpf: @input_control.driver.cpf).destroy_all
      checkin = create_checkin_input(@input_control)
      @input_control.update_attributes(status: InputControl::TypeStatus::DISCHARGE)
      result = InputControls::FinishService.new(@input_control, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Checkin does not have as START")
    end

    it "when checkin has as START" do
      Checkin.input_control.the_day.where(driver_cpf: @input_control.driver.cpf).destroy_all
      @input_control.update_attributes(status: InputControl::TypeStatus::DISCHARGE)
      checkin = create_checkin_input(@input_control)
      checkin = create_checkin_start(@input_control)
      result = InputControls::FinishService.new(@input_control, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Input Control finish successfully.")
    end

    it "when the input_control has already been FINALIZED" do
      Checkin.input_control.the_day.where(driver_cpf: @input_control.driver.cpf).destroy_all
      @input_control.update_attributes(status: InputControl::TypeStatus::DISCHARGE)
      checkin_input = create_checkin_input(@input_control)
      checkin_start = create_checkin_start(@input_control)
      checkin_finish = create_checkin_finish(@input_control)
      result = InputControls::FinishService.new(@input_control, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Input Control already been FINALIZED.")
    end

    it "when input_control is RECEIVED" do

      Checkin.input_control.the_day.where(driver_cpf: @input_control.driver.cpf).destroy_all
      @input_control.reload.update_attributes(status: InputControl::TypeStatus::DISCHARGE)
      checkin_input = create_checkin_input(@input_control)
      checkin_start = create_checkin_start(@input_control)
      result = InputControls::FinishService.new(@input_control, @user).call
      expect(@input_control.reload.status).to equal(InputControl::TypeStatus::RECEIVED)
      expect(Checkin.the_day.input_control.finish.where(driver_cpf: @input_control.driver.cpf).present?).to be_truthy
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Input Control finish successfully.")
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

    def create_checkin_start(input_control)
      Checkin.create!( driver_cpf: input_control.driver.cpf,
                      driver_name: input_control.driver.nome.upcase,
                   operation_type: :input_control,
                     operation_id: input_control.id,
                      place_horse: 'HPX9087',
                     place_cart_1: 'PWM8765',
                     place_cart_2: 'LWK2981',
                             door: 1,
                           status: :start)
    end

    def create_checkin_finish(input_control)
      Checkin.create!( driver_cpf: input_control.driver.cpf,
                      driver_name: input_control.driver.nome.upcase,
                   operation_type: :input_control,
                     operation_id: input_control.id,
                      place_horse: 'HPX9087',
                     place_cart_1: 'PWM8765',
                     place_cart_2: 'LWK2981',
                             door: 1,
                           status: :finish)
    end
end
