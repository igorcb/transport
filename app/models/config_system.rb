class ConfigSystem < ActiveRecord::Base
	validates :config_key, presence: true
	validates :config_value, presence: true
	validates :config_description, presence: true
end
