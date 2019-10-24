module DashboardHelper
  def icon_status_input_control(status)
    case status
      when InputControl::TypeStatus::OPEN then image_tag "square.svg", size:"15x15"
      when InputControl::TypeStatus::FINISH_TYPING then image_tag "square.svg", size:"15x15"
      when InputControl::TypeStatus::DISCHARGE then image_tag "triangle.svg", size:"15x15"
      when InputControl::TypeStatus::CONFERENCE then image_tag "triangle.svg", size:"15x15"
      when InputControl::TypeStatus::RECEIVED then image_tag "circle.svg", size:"15x15"
      else ""
    end
  end

  def icon_status_boarding(status)
    case status
      when Boarding::TipoStatus::ABERTO then image_tag "square.svg", size:"15x15"
      when Boarding::TipoStatus::INICIADO then image_tag "triangle.svg", size:"15x15"
      when Boarding::TipoStatus::EMBARCADO then image_tag "circle.svg", size:"15x15"
      else ""
    end
  end

  def icon_account_receivable(account_receivable)
    case account_receivable.status
      when 2 then "<i class=\"fas fa-check text-success\"></i>".html_safe
      when 1 then ""
      when 0 then "<i class=\"fas fa-exclamation text-danger\"></i>".html_safe
      else ""
    end
  end

  def difference_as_time(start_time, end_time)
    time = TimeDifference.between(start_time,end_time)
    days = time.in_general[:days]
    hours = time.in_general[:hours]
    minute = time.in_general[:minutes]
    if days > 0
      "#{days} dias, #{hours}:#{minute}"
    else
      "#{hours}:#{minute}"
    end
  end
end
