# config/initializers/action_mailer.rb

# if Rails.env.development?
#   # Define settings for mailcatcher
#   Rails.application.config.action_mailer.tap do |action_mailer|
#     action_mailer.delivery_method = :smtp
#     action_mailer.perform_deliveries = true
#     action_mailer.logger = true
#     action_mailer.raise_delivery_errors = true
#     action_mailer.default :charset => "utf-8"
#     action_mailer.default_url_options = { host:'localhost', port: '3000' }
#     action_mailer.smtp_settings = {
#       port: '587',
#       address: ENV['RAILS_MAIL_HOST'],
#       user_name: ENV['RAILS_MAIL_USERNAME'],
#       password: ENV['RAILS_MAIL_PASSWORD'],
#       domain: ENV['RAILS_MAIL_DOMAIN'],
#       authentication: :plain,
#       enable_starttls_auto: true
#     }
#   end
# end

# if Rails.env.production?
  # Define settings for sendgrid
  Rails.application.config.action_mailer.tap do |action_mailer|
    action_mailer.delivery_method = :smtp
    action_mailer.perform_deliveries = true
    action_mailer.raise_delivery_errors = true
    action_mailer.default :charset => "utf-8"
    action_mailer.default_url_options = { host:'l7brasil.com.br' }
    action_mailer.smtp_settings = {
      port: '587',
      address: ENV['RAILS_MAIL_HOST'],
      user_name: ENV['RAILS_MAIL_USERNAME'],
      password: ENV['RAILS_MAIL_PASSWORD'],
      domain: ENV['RAILS_MAIL_DOMAIN'],
      authentication: :plain,
      enable_starttls_auto: true
    }
  end
# end