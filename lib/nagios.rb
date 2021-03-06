module Sciigo
  class Nagios < Hash
    def initialize
      # collect all nagios environment variables for message templates
      # let them override any variables set in the config
      ENV.each do |k, v|
        if k =~ /^NAGIOS_(.+)/
          self.store( $1.downcase.to_sym, v ) unless v.empty?
        end
      end

      raise Sciigo::Error, "Missing Nagios environment variables, is this script being invoked by nagios?" if size == 0

      # parse the protocol from the contact email
      protocol = /^(\w+):\/\/(.*)/.match(fetch('contactemail'))
      if protocol
        self.store(:transport, protocol[1])
        self.store(:contactemail, protocol[2])
      else
        self.store(:transport, nil)
      end
    end

    # override some basic hash functions to make the key lookup more
    # generic and 
    def [](key)
      key = key.to_s unless key.respond_to?(:downcase)
      super(key.downcase.to_sym)
    end

    def fetch(key)
      key = key.to_s unless key.respond_to?(:downcase)
      super(key.downcase.to_sym)
    end

    def has_key?(key)
      key = key.to_s unless key.respond_to?(:downcase)
      super(key.downcase.to_sym)
    end

    def category 
      @category ||= has_key?(:servicedesc) ? :service : :host
    end

    def service?
      category == :service
    end

    def host?
      category == :host
    end

    def type
      @type ||=  fetch(:notificationtype).downcase.to_sym
    end

    # implement object like accessors for the nagios environment variables
    def method_missing( method, *args, &block )
      if has_key?(method)
        fetch(method)
    else
        # don't mess up to other method_missing magic ;)
        super( method, *args, &block ) 
      end
    end
  end
end