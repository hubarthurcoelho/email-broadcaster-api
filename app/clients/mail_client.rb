module MailClient
  def send(to_email:, subject:, content:)
    raise NotImplementedError, "#{self.class} must implement the send method"
  end
end
