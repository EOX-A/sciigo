module Sciigo

  class Error < StandardError
  end

  class Nagios
    @@vars

    def initialize
      # collect all nagios environment variables for message templates
      # let them override any variables set in the config
      @@vars ||= Hash.new()
      ENV.each do |k, v|
        if k =~ /^NAGIOS_(.+)/
          @@vars.store( $1.downcase.to_sym, v ) unless v.empty?
        end
      end unless @@vars.length > 0
    end

    # implement array like accessors for the nagios environment variables
    def [](key)
      fetch(key)
    end

    def fetch(key)
      @@vars[ key.downcase.to_sym ]
    end

    def has_key?(key)
      return @@vars.has_key?( key.downcase.to_sym )
    end

    def to_hash
      return @@vars
    end

    def category 
      type ||= has_key?('SERVICEDESC') ? :service : :host
    end

    def service?
      type == :service
    end

    def host?
      type == :host
    end

    def type
      type ||= @@vars[ :notificationtype ].downcase.to_sym
    end

    # implement object like accessors for the nagios environment variables
    def method_missing( method, *args, &block )
      if @@vars.include?( method.downcase.to_sym )
        @@vars[method.downcase.to_sym]
    else
        # don't mess up to other method_missing magic ;)
        super( method, *args, &block ) 
      end
    end
  end

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

# => Dir["#{Rails.root}/features/steps/shared/*.rb"].each {|file| require file}