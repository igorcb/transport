module CheckinsHelper
  def select_checkin_status
    translate 'activerecord.attributes.enums.checkin.status'
  end

  def select_checkin_operation
    translate 'activerecord.attributes.enums.checkin.operation_type'
  end
end
