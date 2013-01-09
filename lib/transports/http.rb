require 'net/https'

module Sciigo
  module Transport
    class HTTP < Sciigo::Transport::BasicTransport
      def initialize(message)
        super(message)
      end

      protected
      def post(uri, message)
        request(:post, uri, message)
      end

      def get(uri, message)
        request(:get, uri, message)
      end

      private
      def request(type, uri, message)
        begin
          url = URI.parse(uri)

          case type
          when :get 
            request = Net::HTTP::Get.new("#{ url.path }?#{ URI.encode_www_form(message) }")
          when :post
            request = Net::HTTP::Post.new(url.path)
            request.set_form_data(message)
          else
            raise Sciigo::Transport::Error,  'Unsupported HTTP request type %s' % type 
          end

          response = Net::HTTP.new(url.host, url.port)
          
          if( url.port == 443 )
            response.use_ssl = true
            response.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          log.info response.start { |http|
            http.request(request) 
          }
        rescue Exception => e
          log.fatal { 'Exception sending notification, %p' % e }
          exit 1
        end
      end
    end
  end
end