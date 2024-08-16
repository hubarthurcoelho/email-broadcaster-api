class MailService
  def initialize(mail_client:)
    @provider = mail_client
    unless @provider.is_a?(MailClient)
      raise ArgumentError, "mail_client must include MailClient module"
    end
  end

  def send(to_email:, subject:, content:)
    @provider.send(to_email: to_email, subject: subject, content: content)
  end
end
