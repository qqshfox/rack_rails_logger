if Rails.env.development? && defined?(RackRailsLogger)
  Rails.application.middleware.insert 0, RackRailsLogger::Middleware
  Rails.application.middleware.delete Rails::Rack::Logger
end
