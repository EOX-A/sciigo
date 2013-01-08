module Sciigo
  class Nagios
    @@vars = nil

    def initialize
      # collect all nagios environment variables for message templates
      # let them override any variables set in the config
      @@vars ||= Hash.new()
      ENV.each do |k, v|
        if k =~ /^NAGIOS_(.+)/
          @@vars.store( $1.downcase.to_sym, v ) unless v.empty?
        end
      end unless @@vars.length > 0

      raise Sciigo::Error, "Missing Nagios environment variables, is this script being invoked by nagios?" if @@vars.nil? || @@vars.empty?
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
      @category ||= has_key?('SERVICEDESC') ? :service : :host
    end

    def service?
      category == :service
    end

    def host?
      category == :host
    end

    def type
      @type ||= @@vars[ :notificationtype ].downcase.to_sym
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
end