
# config/initializers/sidekiq.rb
require 'sidekiq'
require 'sidekiq/web'

redis_connection = if Gem.win_platform?
  # For Memurai
  'redis://127.0.0.1:6379/0'
  # For WSL, use this instead:
  # 'redis://wsl:6379/0'
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', redis_connection) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', redis_connection) }
end

# Secure the Sidekiq web interface
Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(username, ENV.fetch('SIDEKIQ_USERNAME', 'admin')) &
    ActiveSupport::SecurityUtils.secure_compare(password, ENV.fetch('SIDEKIQ_PASSWORD', 'password'))
end