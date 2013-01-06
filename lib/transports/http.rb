require 'net/https'

module Sciigo
  module Transports
    class HTTP < Sciigo::Transports::BasicTransport
      def initialize(config, data)
        super(config, data)
      end

      protected
      def post(uri)
        request(:post, uri )
      end

      def get(uri)
        request(:get, uri )
      end

      private
      def request(type, uri)
        begin
          url = URI.parse(uri)

          case type
          when :get 
            request = Net::HTTP::Get.new( "#{url.path}?#{URI.encode_www_form( @data )}" )
          when :post
            request = Net::HTTP::Post.new(url.path)
            request.set_form_data( @data )
          else
            raise Sciigo::Transports::Error,  'Unsupported HTTP request type %s' % type 
          end

          response = Net::HTTP.new(url.host, url.port)
          
          if( url.port == 443 )
            response.use_ssl = true
            response.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          log.info response.start { |http|
            http.request( request ) 
          }
        rescue Exception => e
          log.fatal { 'Exception sending notification, %p' % e }
          exit 1
        end
      end
    end
  end
end