class ConfigSystem < ActiveRecord::Base
	validates :config_key, presence: true, uniqueness: true
	validates :config_value, presence: true
	validates :config_description, presence: true

  before_save do |conf| 
    conf.config_key = config_key.upcase 
  end

end
