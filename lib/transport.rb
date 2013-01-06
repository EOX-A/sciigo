module Sciigo
  module Transport
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
        raise Sciigo::Transport::Error, "Abstract Transport, do not instantiate directly!"
      end
    end

    class Error < Sciigo::Error
    end

    class ParameterMissing < Sciigo::Transport::Error
    end
  end
end

# require all the files in the lib/transports directory
Dir["#{File.dirname(__FILE__)}/transports/*.rb"].each { |file|
  require file
}