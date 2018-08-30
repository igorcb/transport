class FileEdi < ActiveRecord::Base

	module TypeFile
		EDI_OCCURRENCE = 0
		EDI_NOTFIS = 1
	end
end
