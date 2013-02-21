require 'active_support/log_subscriber'
require 'active_support/core_ext/hash/except'

module RackRailsLogger
  class LogSubscriber < ActiveSupport::LogSubscriber
    INTERNAL_PARAMS = %w(controller action format _method only_path)

    def start_processing(event)
      payload = event.payload
      params  = payload[:params].except(*INTERNAL_PARAMS)
      queuing_time = payload[:queuing_time]

      debug
      debug
      info %(Processing #{payload[:method]} "#{payload[:path]}" for #{payload[:remote_addr]} at #{Time.now}#{queuing_time && " (Queuing time #{queuing_time}ms)"})
      info "  Parameters: #{params.inspect}" unless params.empty?
    end

    def process_action(event)
      payload   = event.payload
      additions = RackRailsLogger::Middleware.log_process_action(payload)

      status = payload[:status]
      if status.nil? && payload[:exception].present?
        exception_class_name = payload[:exception].first
        status = ActionDispatch::ExceptionWrapper.status_code_for_exception(exception_class_name)
      end
      message = "Completed #{status} #{Rack::Utils::HTTP_STATUS_CODES[status]} in %.0fms" % event.duration
      message << " (#{additions.join(" | ")})" unless additions.blank?

      info(message)
    end
  end
end

RackRailsLogger::LogSubscriber.attach_to :rack
