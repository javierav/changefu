require 'yaml'

module Changefu
  class Configuration
    class << self
      def method_missing(method)
        if config.key?(method)
          config[method]
        else
          abort "You must set `#{method}` directive in `.changefu.yml` file!"
        end
      end

      def respond_to_missing?(method, include_private=false)
        config.key?(method) || super
      end

      private

      def config
        @config ||= YAML.safe_load(
          File.read(Changefu.path_helper!('.changefu.yml')), symbolize_names: true
        )
      end
    end
  end
end
