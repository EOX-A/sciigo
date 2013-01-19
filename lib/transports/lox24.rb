require 'digest/md5'
require './lib/transports/http.rb'

module Sciigo
  module Transport
    class Lox24 < Sciigo::Transport::HTTP
      def initialize(message)
        super(message)
      end

      def uri
        Sciigo.config['lox24']['api']
      end

      def setup
        @data = { :to         => message.recipient, 
                  :konto      => Sciigo.config['lox24']['konto'],
                  :password   => Digest::MD5.hexdigest(config['lox24']['password']),
                  :service    => Sciigo.config['lox24']['service'],
                  :from       => Sciigo.config['lox24']['from'],
                  :text       => "#{message.title}\n#{message.message}\n#{Sciigo.config['nagios']['url']}",
                  :return     => 'xml',
                  :httphead   => 1
                  } 
      end

      def validate
        raise Sciigo::Transport::ParameterMissing.new if @data[:konto].nil? || @data[:password].nil? || @data[:service].nil? || @data[:from].nil? || @data[:to].nil? || @data[:text].nil? || @data[:text].empty?
      end

      def send
        setup
        validate
        post(uri, @data)
      end
    end
  end
end