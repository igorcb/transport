# config/initializers/action_mailer.rb

if Rails.env.development?
  # Define settings for mailcatcher
  Rails.application.config.action_mailer.tap do |action_mailer|
    action_mailer.delivery_method = :smtp
    action_mailer.perform_deliveries = true
    action_mailer.raise_delivery_errors = false
    action_mailer.smtp_settings = {address: "localhost", port: 1025}
  end
end

if Rails.env.production?
  # Define settings for sendgrid
  Rails.application.config.action_mailer.tap do |action_mailer|
    action_mailer.delivery_method = :smtp
    action_mailer.perform_deliveries = true
    action_mailer.raise_delivery_errors = true
    action_mailer.smtp_settings = {
      address: ENV['RAILS_MAIL_HOST'],
      port: '587',
      authentication: :plain,
      user_name: ENV['RAILS_MAIL_USERNAME'],
      password: ENV['RAILS_MAIL_PASSWORD'],
      domain: ENV['RAILS_MAIL_DOMAIN'],
      enable_starttls_auto: true
    }
  end
end
