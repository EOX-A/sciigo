require './lib/transports/http.rb'

module Sciigo
  module Transport
    class Pushover < Sciigo::Transport::HTTP
      def initialize(message)
        super(message)
      end

      def uri
        config['pushover']['api']
      end

      def setup
        string, user, device = /([A-Za-z0-9]{30}):?([A-Za-z0-9_-]{1,25})?/.match(message.recipient).to_a
        @data = { :user     => user, 
                  :device   => device,
                  :token      => config['pushover']['token'], 
                  :priority => message.priority ? '1' : '0',
                  :message    => message.message,
                  :title      => message.title,
                  :timestamp  => message.time.to_i,
                  :url        => message.url,
                  :url_title  => "Show in Nagios"
                  }
      end

      def validate
        raise Sciigo::Transport::ParameterMissing.new if @data[:token].nil? || @data[:user].nil? || @data[:message].nil? || @data[:message].empty?
      end

      def send
        setup
        validate
        post(uri, @data)
      end
    end
  end
end