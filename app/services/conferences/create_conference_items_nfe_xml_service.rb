module Conferences
  class CreateConferenceItemsNfeXmlService
    #Service usado apenas para automatizar os items a ser inclusos na conferencia
    #Usar apenas para testes
    def initialize(input_control, user)
      @user = user
      @input_control = input_control
    end

    def call
      # byebug
      @conference = @input_control.conferences.last
      @conference = @input_control.conferences.create(user_id: @user.id) if !@input_control.conferences.present?
      item_input_controls = @input_control.item_input_controls
      item_input_controls.each do |i|
        result = Conferences::ConferenceItemCreateService.new(input_control_id: @input_control.id, product_id: i.product_id, qtde_oper: i.qtde.to_f).call
      end
      @input_control.update_attributes(status: InputControl::TypeStatus::CONFERENCE)
      @conference.update_attributes(status: :start, start_time: Time.now, finish_time: nil, approved: nil, user_id: @user.id)
    end

    private
  end
end
