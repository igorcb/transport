module CheckinsHelper
  def select_checkin_type
    translate 'activerecord.attributes.enums.checkin.type'
  end

  def select_checkin_operation
    translate 'activerecord.attributes.enums.checkin.operation_type'
  end
end
