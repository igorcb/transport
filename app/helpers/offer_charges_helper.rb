module OfferChargesHelper

	def select_vehicle_situation
	 ([["Aguardando", 0], 
     ["Confirmado", 1],
     ["Rejeitado", 2]
    ])
	end

	def select_status_offer
	 ([["Aberto", 0], 
     ["Fechado", 1],
     ["Cancelado", 2]
    ])
	end
end
