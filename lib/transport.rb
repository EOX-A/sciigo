module Sciigo
  module Transport
    
    def self.new(transport, message)
      raise Error, "No transport specified" unless transport
      
      require "#{File.dirname(__FILE__)}/transports/#{transport}.rb"
      return Sciigo::Transport.const_get(transport.to_s.capitalize).new(message)
    end

    class BasicTransport
      def initialize(message)
        @message = message
      end

      def send
        raise Sciigo::Transport::Error, "#{self.class.name} didn't implement the send method!"
      end

      private
      def message
        @message
      end
    end

    class Error < Sciigo::Error
    end

    class ParameterMissing < Sciigo::Transport::Error
    end
  end
end