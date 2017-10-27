module OfferDriversHelper
	def select_status_offer_driver
	 ([["Aguardando", 0], 
     ["Confirmado", 1],
     ["Rejeitado", 2],
     ["No Show", 3],
     ["Desistência", 4]
    ])
	end	
end
