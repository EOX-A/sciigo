require 'uri'

module Sciigo
  class Message
    @@templates = ::YAML.load_file(File.join(Sciigo.conf_dir, 'templates.yml'))

    def initialize(notification)
      @notification = notification
      @time = Time.now
      @category = @notification.category.to_s
      @type = @notification.type.to_s
    end

    def recipient
      @recipient ||= @notification.contactemail
    end

    def message
      return @message ||= Mustache.render(template('message'), @notification)
    end

    def title
      return @title ||= Mustache.render(template('title'), @notification)
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
      begin
        return @@templates[ @category ][ @type ][ tmpl ] if @@templates[ @category ][ @type ].has_key? tmpl
        return @@templates[ @category ][ 'default' ][ tmpl ] if @@templates[ @category ][ 'default' ].has_key? tmpl
        return @@templates[ 'default' ][ tmpl ] if @@templates[ 'default' ].has_key? tmpl
      rescue NoMethodError => e
        return nil
      end
      return nil
    end

  end
end