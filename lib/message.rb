module Sciigo
  class Message
    def initialize
      @notification = Sciigo::Nagios.new
      @time = Time.now
    end

    def to
      recipient ||= @notification.contactemail
    end

    def content
      ""
    end

    def title
      ""
    end

    def time
      @time
    end

    def url

    end

  end
end