require "sendgrid-ruby"

class SendGridClient
  include SendGrid
  include MailClient

  def initialize(api_key: ENV["SENDGRID_API_KEY"], domain: ENV["SENDGRID_DOMAIN"])
    @api = SendGrid::API.new(api_key: api_key)
    @sender = domain
  end

  def send(to_email:, subject:, content:)
    to = Email.new(email: to_email)
    from = Email.new(email: @sender)
    content = build_content(content: content)

    mail = build_mail(from: from, to: to, subject: subject, content: content)

    send_email(mail: mail)

    rescue StandardError => e
      { body: nil, error: e.message }
  end

  private

  def build_content(content:)
    Content.new(type: "text/plain", value: content)
  end

  def build_mail(from:, to:, subject:, content:)
    Mail.new(from, subject, to, content)
  end

  def send_email(mail:)
    response = @api.client.mail._("send").post(request_body: mail.to_json)

    if response.status_code.to_i > 299
      { body: nil, error: "Failed to send email. Status code: #{response.status_code}, Error: #{response.body}" }
    else
      { body: response.body, error: nil }
    end
  end
end
