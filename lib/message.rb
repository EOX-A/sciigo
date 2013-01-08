require 'uri'

module Sciigo
  class Message
    @@templates = ::YAML.load_file('config/templates.yml')

    def initialize(notification)
      @notification = notification
      @time = Time.now
      @template = @@templates[ @notification.category ][ @notification.type ]
    end

    def recipient
      @recipient ||= @notification.contactemail
    end

    def message
      return @message ||= Liquid::Template.parse(template('message'))
    end

    def title
      return @message ||= Liquid::Template.parse(template('title')) 
    end

    def time
      @time
    end

    def priority
      @priority ||= template('priority') == 1
    end

    def url
      # service notifications
      if @notification.service?
        return @notification['serviceactionurl'] if @notification.has_key?('serviceactionurl')
        return "#{Sciigo.config['nagios']['extinfo']}?type=2&host=#{@notification['hostname']}&service=#{URI.escape(@notification['servicedesc'])}"
      end

      # host notifications
      if @notification.host?
        return @notification['hostactionurl'] if @notification.has_key?('hostactionurl')
        return "#{Sciigo.config['nagios']['extinfo']}?type=1&host=#{@notification['hostname']}"
      end

      # link to the main nagios site if all else fails
      return Sciigo.config['nagios']['url'] if Sciigo.config['nagios'].has_key?('url')
    end

    def notification
      @notification
    end

    private
    def template(tmpl)
      raise Sciigo::Error if tmpl.nil? || tmpl.empty?
      return @@templates[ @notification.category ][ @notification.type ][ tmpl ] if @@templates[ @notification.category ][ @notification.type ].has_key? tmpl
      return @@templates[ @notification.category ][ 'default' ][ tmpl ] if @@templates[ @notification.category ][ 'default' ].has_key? tmpl
      return @@templates[ 'default' ][ tmpl ] if @@templates[ 'default' ].has_key? tmpl
      return nil
    end

  end
end