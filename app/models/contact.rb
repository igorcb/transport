class Contact < ActiveRecord::Base

	module TipoContato
		FIXO     = 0
		CELULAR  = 1
		EMAIL    = 2
		TWITTER  = 3
		FACEBOOK = 4
	end

end
