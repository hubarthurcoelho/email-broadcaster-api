module Providers
  class EmailSender
    def send(to_email:, subject:, content:)
      raise NotImplementedError, "#{self.class} must implement send_email method"
    end
  end
end
