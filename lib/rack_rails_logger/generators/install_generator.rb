require 'rails/generators'

module RackRailsLogger
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Copy RackRailsLogger default files"
      def copy_initialize
        copy_file "rack_rails_logger.rb", "config/initializers/rack_rails_logger.rb"
      end
    end
  end
end
