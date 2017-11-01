module OfferDriversHelper
	def select_status_offer_driver
	 ([["Aguardando", 0], 
     ["Confirmado", 1],
     ["Rejeitado", 2],
     ["No Show", 3],
     ["Desistência", 4]
    ])
	end	

  def status_driver_color(offer_driver, status, status_name)
    case status
      when 0 then status_name
      when 1 then "<i class='fa fa-check' style='color: LimeGreen' aria-hidden='true'></i> #{status_name}".html_safe
      when 2 then "#{link_to_reject(offer_driver)} ".html_safe
      when 3 then "<i class='fa fa-square-o' style='color: red' aria-hidden='true'></i> #{status_name}".html_safe
      when 4 then "<i class='fa fa-minus-square' style='color: orange' aria-hidden='true'></i> #{status_name}".html_safe

          # <%= link_to reject_form_offer_driver_path(offer_driver) do %>
          #     <span title="Rejeitar" class="fa fa-times fa-2x" style='color: red' aria-hidden='true'></span> 
          # <% end %>        
    end
  end

  def link_to_reject(offer_driver)
    #link_to "Reject", reject_observation_offer_driver_path(offer_driver), {:target => "_blank"}.merge(class: "fa fa-times danger'")
    link_to reject_observation_offer_driver_path(offer_driver) do
      "<span title='Rejeitar' class='fa fa-times' style='color: red' aria-hidden='true'></span> Reject".html_safe
    end    
  end
end
