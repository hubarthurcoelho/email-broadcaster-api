module Services
  class Email
    def initialize(email_sender_provider:)
      @provider = email_sender_provider
      unless @provider.respond_to?(:send)
        raise ArgumentError, "Email sender provider must implement send method"
      end
    end

    def send(to_email:, subject:, content:)
      @provider.send(to_email: to_email, subject: subject, content: content)
    end
  end
end
