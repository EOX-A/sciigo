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

          http = Net::HTTP.new(url.host, url.port)
          if url.port == 443
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER

            # use a bundled version of the mozilla certificate authorities
            # see http://curl.haxx.se/ca/cacert.pem for more information
            http.ca_file = File.join(Sciigo.conf_dir, "ca-bundle.crt")
          end

          response = http.start { |h|
            h.request(request) 
          }

          Sciigo.log.info { response.inspect }
          Sciigo.log.debug { response.to_hash }
          Sciigo.log.debug { response.body }
        rescue Exception => e
          Sciigo.log.fatal { 'Exception sending notification, %p' % e }
          exit 1
        end
      end
    end
  end
end