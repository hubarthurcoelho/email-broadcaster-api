class MailService
  def initialize(client: SendGridClient.new)
    @provider = client
    unless @provider.is_a?(MailClient)
      raise ArgumentError, "client must include MailClient module"
    end
  end

  def send(to_email:, subject:, content:)
    # todo: validate email fmt, validate existence of subject/content

    @provider.send(to_email: to_email, subject: subject, content: content)
  end
end
