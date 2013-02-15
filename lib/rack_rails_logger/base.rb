require 'action_dispatch'
require 'active_support/notifications'
require 'active_support/core_ext/module/attr_internal'
require 'benchmark'
require 'active_support/core_ext/benchmark.rb'

module RackRailsLogger
  class Base

    attr_internal :rack_runtime

    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)

      raw_payload = {
        :params      => request.filtered_parameters,
        :method      => request.method,
        :path        => (request.fullpath rescue "unknown"),
        :remote_addr => request.remote_addr,
      }

      ActiveSupport::Notifications.instrument("start_processing.rack", raw_payload.dup)

      ActiveSupport::Notifications.instrument("process_action.rack", raw_payload) do |payload|
        result = nil
        self.rack_runtime = cleanup_rack_runtime do
          Benchmark.ms { result = @app.call(env) }
        end
        payload[:status] = result[0]
        append_info_to_payload(payload)
        result
      end
    end

    def self.log_process_action(payload)
      messages, rack_runtime = [], payload[:rack_runtime]
      messages << ("Rack: %.1fms" % rack_runtime.to_f) if rack_runtime
      messages
    end

    private

    def cleanup_rack_runtime
      yield
    end

    def append_info_to_payload(payload)
      payload[:rack_runtime] = rack_runtime
    end

  end
end
