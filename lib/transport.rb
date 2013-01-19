module Sciigo
  module Transport
    
    def self.new(transport, message)
      raise Sciigo::Transport::Error, "No transport specified" unless transport
      
      begin
        require "#{File.dirname(__FILE__)}/transports/#{transport}.rb"
        return Sciigo::Transport.const_get(transport.to_s.capitalize).new(message)
      rescue LoadError => e
        raise Sciigo::Transport::UnknownTransport, "Coud not load transport #{transport.to_s.capitalize}"
      end
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

    class UnknownTransport < Sciigo::Transport::Error
    end

    class ParameterMissing < Sciigo::Transport::Error
    end
  end
end