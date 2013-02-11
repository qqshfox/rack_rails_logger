Rails.application.middleware.insert_after Rails::Rack::Logger, RackRailsLogger::Middleware if Rails.env.development?
