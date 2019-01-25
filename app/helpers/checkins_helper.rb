module CheckinsHelper
  def select_checkin_status
    translate 'activerecord.attributes.enums.checkin.status'
  end

  def select_checkin_operation
    translate 'activerecord.attributes.enums.checkin.operation_type'
  end

  def time_between_checkin_to_start(checkin)
    #checkin = Checkin.find(checkin_id)
    checkin_input = Checkin.the_day.input.where(driver_cpf: checkin.driver_cpf).last
    checkin_start = Checkin.the_day.start.where(driver_cpf: checkin.driver_cpf).last
    checkin_start.created_at.to_time - checkin_input.created_at.to_time
  end
end
