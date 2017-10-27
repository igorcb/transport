module OfferDriversHelper
	def select_status_offer_driver
	 ([["Aguardando", 0], 
     ["Confirmado", 1],
     ["Rejeitado", 2],
     ["No Show", 3],
     ["Desistência", 4]
    ])
	end	

  def status_driver_color(status, status_name)
    case status
      when 0 then status_name
      when 1 then "<i class='fa fa-check' style='color: LimeGreen' aria-hidden='true'></i> #{status_name}".html_safe
      when 2 then "<i class='fa fa-times' style='color: red' aria-hidden='true'></i> #{status_name}".html_safe
      when 3 then "<i class='fa fa-square-o' style='color: red' aria-hidden='true'></i> #{status_name}".html_safe
      when 4 then "<i class='fa fa-minus-square' style='color: orange' aria-hidden='true'></i> #{status_name}".html_safe
    end
  end
end
