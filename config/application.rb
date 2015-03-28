require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require 'csv'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Transport
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # I18n.config.enforce_available_locales = false
    # config.i18n.available_locales = [:"pt-BR", :en]
    # config.i18n.default_locale = "pt-BR"
    #config.i18n.enforce_available_locales = true
    config.time_zone = 'Brasilia'
    #config.assets.prefix = '/assets'
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    Paperclip.options[:command_path] = "/usr/bin/"
    #config.autoload_paths += %W(#{config.root}/lib)
    config.watchable_dirs['lib'] = [:rb]
  end
end
