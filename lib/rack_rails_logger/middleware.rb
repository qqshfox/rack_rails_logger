require 'action_dispatch'
require 'active_support/notifications'

module RackRailsLogger
  middleware = Class.new do

    def initialize(app)
      @app = app
    end

    def call(*args, &block)
      process_action(*args, &block)
    end

    def process_action(env)
      request = ActionDispatch::Request.new(env)
      queue_start_time = env["HTTP_X_QUEUE_START"] || env["HTTP_X_REQUEST_START"]
      queuing_time = queue_start_time && (Time.now.to_f * 1_000_000 - queue_start_time.gsub("t=", "").to_i) / 1000

      raw_payload = {
        :params      => request.filtered_parameters,
        :method      => request.method,
        :path        => (request.fullpath rescue "unknown"),
        :remote_addr => request.remote_addr,
        :queuing_time => queuing_time
      }

      ActiveSupport::Notifications.instrument("start_processing.rack", raw_payload.dup)

      ActiveSupport::Notifications.instrument("process_action.rack", raw_payload) do |payload|
        result = @app.call(env)
        payload[:status] = result[0]
        append_info_to_payload(payload)
        result
      end
    end

    def self.log_process_action(payload)
      []
    end

    private

    def cleanup_rack_runtime
      yield
    end

    def append_info_to_payload(payload)
    end

  end

  class Middleware < middleware
  end
end
