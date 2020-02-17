module Checkins
  class DestroyService
    def initialize(checkin)
      @checkin = checkin
    end
    def call
      return {success: false, message: "checkin is not present."} if @checkin.nil?
      return {success: false, message: "checkin is not associated."} if @checkin.operation_id.nil?
      begin
        ActiveRecord::Base.transaction do
          Event.create!(controller_name: "Checkin", action_name: "destroy", what: "Excluiu o checkin, No: #{@checkin.id}, do motorista: #{@checkin.driver_name} que foi criado em: #{@checkin.created_at}")
          @checkin.destroy
        end
        return {success: true, message: "success!"}
      rescue => e
        return {success: false, message: e.message}
      end
    end
  end
end