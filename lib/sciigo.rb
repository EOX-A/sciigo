module Sciigo
  module Transports
    class BasicTransport
      def initialize(config, data)
        @config = config
        @data = data
      end

      private
      def log
        @config['LOGGER']
      end

      def config
        @config
      end

      def data
        @data
      end

      def send
        raise Sciigo::Transports::Error, "Abstract Transport, do not instantiate directly!"
      end
    end

    class Error < Sciigo::Error
    end

    class ParameterMissing < Sciigo::Transports::Error
    end
  end

end