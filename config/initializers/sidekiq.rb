Sidekiq.configure_server do |config|
  #Docker
  #config.redis = { url: 'redis://redis:6379/0' }
  config.redis = { url: 'redis://127.0.0.1:6379/0' }
end

Sidekiq.configure_client do |config|
  #Docker
  #config.redis = { url: 'redis://redis:6379/0' }
  config.redis = { url: 'redis://127.0.0.1:6379/0' }
end
